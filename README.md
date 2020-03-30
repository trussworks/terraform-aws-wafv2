# terraform-aws-wafv2

Creates a WAF using AWS WAFv2 and AWS Managed Rule Sets.

Three variables control the configuration of each managed rule set:

| Variable prefix | Description|
|-----------------|------------|
| enable\_ | Whether to include the rule set |
| count\_ | Whether to set the rule set's OverrideAction to Count |
| excluded\_rules\_ | List of rules to exclude from the rule set |


## Usage

Example that will enable all rules from the AWSManagedRulesCommonRuleSet:

```hcl
module "waf" {
  source                 = "../terraform-aws-wafv2"

  name                   = "albwaf"
  scope                  = "REGIONAL"
  enable_common_rule_set = true
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| count\_anonymous\_ip\_list | Whether to set the override action to count for the AWS Managed Anonymous IP List. | `bool` | `false` | no |
| count\_common\_rule\_set | Whether to set the override action to count for the AWS Managed Common Rule Set. | `bool` | `false` | no |
| count\_ip\_reputation\_list | Whether to set the override action to count for the AWS Managed IP Reputation List. | `bool` | `false` | no |
| count\_known\_bad\_inputs | Whether to set the override action to count for the AWS Managed Known Bad Inputs. | `bool` | `false` | no |
| count\_linux\_os | Whether to set the override action to count for the AWS Managed Linux OS Rule Set. | `bool` | `false` | no |
| count\_posix | Whether to set the override action to count for the AWS Managed POSIX Rule Set. | `bool` | `false` | no |
| count\_sqli | Whether to set the override action to count for the AWS Managed SQLi Rule Set. | `bool` | `false` | no |
| enable\_anonymous\_ip\_list | Whether to include the AWS Managed Anonymous IP List. | `bool` | `false` | no |
| enable\_common\_rule\_set | Whether to include the AWS Managed Common Rule Set. | `bool` | `false` | no |
| enable\_ip\_reputation\_list | Whether to include the AWS Managed IP Reputation List. | `bool` | `false` | no |
| enable\_known\_bad\_inputs | Whether to include the AWS Managed Known Bad Inputs. | `bool` | `false` | no |
| enable\_linux\_os | Whether to include the AWS Managed Linux OS Rule Set. | `bool` | `false` | no |
| enable\_posix | Whether to include the AWS Managed POSIX Rule Set. | `bool` | `false` | no |
| enable\_sqli | Whether to include the AWS Managed SQLi Rule Set. | `bool` | `false` | no |
| excluded\_rules\_anonymous\_ip\_list | List of rules to exclude from the AWS Managed Anonymous IP List. | `list(string)` | `[]` | no |
| excluded\_rules\_common\_rule\_set | List of rules to exclude from the AWS Managed Common Rule Set. | `list(string)` | `[]` | no |
| excluded\_rules\_ip\_reputation\_list | List of rules to exclude from the AWS Managed IP Reputation List. | `list(string)` | `[]` | no |
| excluded\_rules\_known\_bad\_inputs | List of rules to exclude from the AWS Managed Known Bad Inputs. | `list(string)` | `[]` | no |
| excluded\_rules\_linux\_os | List of rules to exclude from the AWS Managed Linux OS Rule Set. | `list(string)` | `[]` | no |
| excluded\_rules\_posix | List of rules to exclude from the AWS Managed POSIX Rule Set. | `list(string)` | `[]` | no |
| excluded\_rules\_sqli | List of rules to exclude from the AWS Managed SQLi Rule Set. | `list(string)` | `[]` | no |
| name | A name to apply to this Web ACL. | `string` | n/a | yes |
| scope | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
