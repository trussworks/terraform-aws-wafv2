# terraform-aws-wafv2

Creates a WAF using AWS WAFv2 and AWS Managed Rule Sets.

## Usage

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| aws | ~> 2.68 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.68 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | ARN of the Application Load Balancer (ALB) to be associated with the Web Application Firewall (WAF) Access Control List (ACL). | `string` | `""` | no |
| associate\_alb | Whether to associate an Application Load Balancer (ALB) with an Web Application Firewall (WAF) Access Control List (ACL). | `bool` | `false` | no |
| managed\_rules | List of Managed WAF rules. | <pre>list(object({<br>    name           = string<br>    priority = number<br>    override_action = string<br>    excluded_rules = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "override_action": "none",<br>    "priority": 10<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesAmazonIpReputationList",<br>    "override_action": "none",<br>    "priority": 20<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br>    "override_action": "none",<br>    "priority": 30<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesSQLiRuleSet",<br>    "override_action": "none",<br>    "priority": 40<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesLinuxRuleSet",<br>    "override_action": "none",<br>    "priority": 50<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesUnixRuleSet",<br>    "override_action": "none",<br>    "priority": 60<br>  }<br>]</pre> | no |
| name | A friendly name of the WebACL. | `string` | n/a | yes |
| scope | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the bucket. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
