# terraform-aws-wafv2

Creates AWS WAFv2 ACL and supports the following

* AWS Managed Rule Sets
* Associating with Application Load Balancers (ALB)
* Blocking IP Sets
* Global IP Rate limiting
* Custom IP rate limiting for different URLs

**As of 12/2/2020, AWS GovCloud does not support the `AWSManagedRulesAmazonIpReputationList` managed rule set,
which is enabled by default in this module. Until AWS supports that rule set, you will need to define your own `managed_rules`.**

## Terraform Versions

Terraform 0.13 and newer. Pin module version to ~> 2.0. Submit pull-requests to master branch.

Terraform 0.12. Pin module version to ~> 1.0. Submit pull-requests to terraform012 branch.

## Usage with CloudFront

**Note: The Terraform AWS provider needs to be associated with the us-east-1 region to use with CloudFront.**

```hcl
module "cloudfront_wafv2" {
  source  = "trussworks/wafv2/aws"
  version = "0.0.1"

  name  = "cloudfront-web-acl"
  scope = "CLOUDFRONT"
}
```

## Usage with Application Load Balancer (ALB)

```hcl
module "alb_wafv2" {
  source  = "trussworks/wafv2/aws"
  version = "0.0.1"

  name  = "alb-web-acl"
  scope = "REGIONAL"

  alb_arn       = aws_lb.alb.arn
  associate_alb = true
}
```

## Usage blocking IP Sets

```hcl
resource "aws_wafv2_ip_set" "ipset" {
  name = "blocked_ips"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "1.2.3.4/32",
    "5.6.7.8/32"
  ]
}

module "wafv2" {
  source = "../../"

  name   = "wafv2"
  scope = "REGIONAL"

  ip_sets_rule = [
    {
      name       = "blocked_ips"
      action     = "block"
      priority   = 1
      ip_set_arn = aws_wafv2_ip_set.ipset.arn
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | ARN of the ALB to be associated with the WAFv2 ACL. | `string` | `""` | no |
| associate\_alb | Whether to associate an ALB with the WAFv2 ACL. | `bool` | `false` | no |
| filtered\_header\_rule | HTTP header to filter . Currently supports a single header type and multiple header values. | <pre>object({<br>    header_types = list(string)<br>    priority     = number<br>    header_value = string<br>    action       = string<br>  })</pre> | <pre>{<br>  "action": "block",<br>  "header_types": [],<br>  "header_value": "",<br>  "priority": 1<br>}</pre> | no |
| group\_rules | List of WAFv2 Rule Groups. | <pre>list(object({<br>    name            = string<br>    arn             = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>  }))</pre> | `[]` | no |
| ip\_rate\_based\_rule | A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | <pre>object({<br>    name     = string<br>    priority = number<br>    limit    = number<br>    action   = string<br>  })</pre> | `null` | no |
| ip\_rate\_url\_based\_rules | A rate and url based rules tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | <pre>list(object({<br>    name                  = string<br>    priority              = number<br>    limit                 = number<br>    action                = string<br>    search_string         = string<br>    positional_constraint = string<br>  }))</pre> | `[]` | no |
| ip\_sets\_rule | A rule to detect web requests coming from particular IP addresses or address ranges. | <pre>list(object({<br>    name       = string<br>    priority   = number<br>    ip_set_arn = string<br>    action     = string<br>  }))</pre> | `[]` | no |
| managed\_rules | List of Managed WAF rules. | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "override_action": "none",<br>    "priority": 10<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesAmazonIpReputationList",<br>    "override_action": "none",<br>    "priority": 20<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br>    "override_action": "none",<br>    "priority": 30<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesSQLiRuleSet",<br>    "override_action": "none",<br>    "priority": 40<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesLinuxRuleSet",<br>    "override_action": "none",<br>    "priority": 50<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesUnixRuleSet",<br>    "override_action": "none",<br>    "priority": 60<br>  }<br>]</pre> | no |
| name | A friendly name of the WebACL. | `string` | n/a | yes |
| scope | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the WAFv2 ACL. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | The ARN of the WAF WebACL. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
pre-commit install --install-hooks
```

### Testing

[Terratest](https://github.com/gruntwork-io/terratest) is being used for
automated testing with this module. Tests in the `test` folder can be run
locally by running the following command:

```text
make test
```

Or with aws-vault:

```text
AWS_VAULT_KEYCHAIN_NAME=<NAME> aws-vault exec <PROFILE> -- make test
