package test

import (
	"fmt"
	"net/http"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// Simple function to generate enough HTTP GET requests to trigger WAF rate limiting
func simpleDos(url string, requests int) {
	if requests--; requests > 0 {
		// drop errors as we don't really need the response
		/* #nosec */
		resp, _ := http.Get(url)
		// bail out if we get a 403 response before finishing
		if resp.StatusCode == 403 {
			return
		}
		simpleDos(url, requests)
	}
}

func TestTerraformAwsWafv2AlbBlockIp(t *testing.T) {
	t.Parallel()

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/alb")
	testName := fmt.Sprintf("terratest-wafv2-alb-%s", strings.ToLower(random.UniqueId()))
	awsRegion := "us-west-2"
	vpcAzs := aws.GetAvailabilityZones(t, awsRegion)[:3]
	fixedResponse := fmt.Sprintf("Hello world! %s", testName)

	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"test_name":                 testName,
			"vpc_azs":                   vpcAzs,
			"fixed_response":            fixedResponse,
			"enable_block_all_ips":      false,
			"enable_ip_rate_limit":      false,
			"enable_rate_limit_url_foo": false,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Confirm we can access the ALB before blocking IPs
	AlbDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s", AlbDNSName)
	http_helper.HttpGetWithRetry(t, url, nil, 200, fixedResponse, 3, 5*time.Second)

	// Apply with rule to block all IP addresses
	terraformOptions = &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"test_name":                 testName,
			"vpc_azs":                   vpcAzs,
			"fixed_response":            fixedResponse,
			"enable_block_all_ips":      true,
			"enable_ip_rate_limit":      false,
			"enable_rate_limit_url_foo": false,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	terraform.InitAndApply(t, terraformOptions)

	// Confirm we get blocked by IP sets rule in the WAF
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 10, 5*time.Second, func(status int, body string) bool {
		return status == 403
	})
}

func TestTerraformAwsWafv2AlbUrlRateLimit(t *testing.T) {
	t.Parallel()

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/alb")
	testName := fmt.Sprintf("terratest-wafv2-alb-%s", strings.ToLower(random.UniqueId()))
	awsRegion := "us-west-2"
	vpcAzs := aws.GetAvailabilityZones(t, awsRegion)[:3]
	fixedResponse := fmt.Sprintf("Hello world! %s", testName)

	// Apply with rule to rate limit /foo/
	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"test_name":                 testName,
			"vpc_azs":                   vpcAzs,
			"fixed_response":            fixedResponse,
			"enable_block_all_ips":      false,
			"enable_ip_rate_limit":      false,
			"enable_rate_limit_url_foo": true,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	AlbDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s/foo/", AlbDNSName)

	// Ensure /foo/ is working
	http_helper.HttpGetWithRetry(t, url, nil, 200, fixedResponse, 3, 5*time.Second)

	// Generate enough load to trigger the rate limits at the WAF and
	// confirm that we start seeing 403s to /foo/
	requests := 5000
	logger.Logf(t, "Generating %d HTTP GET requests to %s", requests, url)
	simpleDos(url, requests)
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 3, time.Millisecond, func(status int, body string) bool {
		return status == 403
	})

	// Since we didn't generate load to /bar/ we should expect
	// successful responses
	url = fmt.Sprintf("http://%s/bar/", AlbDNSName)
	http_helper.HttpGetWithRetry(t, url, nil, 200, fixedResponse, 3, 5*time.Second)

}

func TestTerraformAwsWafv2AlbIpRateLimit(t *testing.T) {
	t.Parallel()

	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/alb")
	testName := fmt.Sprintf("terratest-wafv2-alb-%s", strings.ToLower(random.UniqueId()))
	awsRegion := "us-west-2"
	vpcAzs := aws.GetAvailabilityZones(t, awsRegion)[:3]
	fixedResponse := fmt.Sprintf("Hello world! %s", testName)

	// Apply with rule to enable ip rate limits
	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"test_name":                 testName,
			"vpc_azs":                   vpcAzs,
			"fixed_response":            fixedResponse,
			"enable_block_all_ips":      false,
			"enable_ip_rate_limit":      true,
			"enable_rate_limit_url_foo": false,
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	AlbDNSName := terraform.Output(t, terraformOptions, "alb_dns_name")
	url := fmt.Sprintf("http://%s/%s/", AlbDNSName, testName)

	// Ensure /$testName is working
	http_helper.HttpGetWithRetry(t, url, nil, 200, fixedResponse, 3, 5*time.Second)

	// Generate enough load to trigger the rate limits at the WAF and
	// confirm that we start seeing 403s
	requests := 5000
	logger.Logf(t, "Generating %d HTTP GET requests to %s", requests, url)
	simpleDos(url, requests)
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 3, time.Millisecond, func(status int, body string) bool {
		return status == 403
	})

}
