package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

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
