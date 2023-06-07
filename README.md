# terraform-aws-wafv2

Creates AWS WAFv2 ACL and supports the following

- AWS Managed Rule Sets
- Associating with Application Load Balancers (ALB)
- Blocking IP Sets
- Global IP Rate limiting
- Custom IP rate limiting for different URLs

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

## Usage with Logging Configuraion of CloudWatchLogs

```hcl
module "alb_wafv2" {
  source  = "trussworks/wafv2/aws"
  version = "0.0.1"

  name  = "cloudfront-web-acl"
  scope = "CLOUDFRONT"

  enable_logging = true
  log_destination_arns = [
    aws_cloudwatch_log_group.logs.arn
  ]
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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn | ARN of the ALB to be associated with the WAFv2 ACL. | `string` | `""` | no |
| associate\_alb | Whether to associate an ALB with the WAFv2 ACL. | `bool` | `false` | no |
| default\_action | The action to perform if none of the rules contained in the WebACL match. | `string` | `"allow"` | no |
| enable\_logging | Whether to associate Logging resource with the WAFv2 ACL. | `bool` | `false` | no |
| filtered\_header\_rule | HTTP header to filter . Currently supports a single header type and multiple header values. | ```object({ header_types = list(string) priority = number header_value = string action = string search_string = string })``` | ```{ "action": "block", "header_types": [], "header_value": "", "priority": 1, "search_string": "" }``` | no |
| group\_rules | List of WAFv2 Rule Groups. | ```list(object({ name = string arn = string priority = number override_action = string }))``` | `[]` | no |
| ip\_rate\_based\_rule | A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | ```object({ name = string priority = number limit = number action = string response_code = optional(number, 403) })``` | `null` | no |
| ip\_rate\_url\_based\_rules | A rate and url based rules tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | ```list(object({ name = string priority = number limit = number action = string response_code = optional(number, 403) search_string = string positional_constraint = string }))``` | `[]` | no |
| ip\_sets\_rule | A rule to detect web requests coming from particular IP addresses or address ranges. | ```list(object({ name = string priority = number ip_set_arn = string action = string response_code = optional(number, 403) }))``` | `[]` | no |
| log\_destination\_arns | The Amazon Kinesis Data Firehose, Cloudwatch Log log group, or S3 bucket Amazon Resource Names (ARNs) that you want to associate with the web ACL. | `list(string)` | `[]` | no |
| managed\_rules | List of Managed WAF rules. | ```list(object({ name = string priority = number override_action = string vendor_name = string version = optional(string) rule_action_override = list(object({ name = string action_to_use = string })) }))``` | ```[ { "name": "AWSManagedRulesCommonRuleSet", "override_action": "none", "priority": 10, "rule_action_override": [], "vendor_name": "AWS" }, { "name": "AWSManagedRulesAmazonIpReputationList", "override_action": "none", "priority": 20, "rule_action_override": [], "vendor_name": "AWS" }, { "name": "AWSManagedRulesKnownBadInputsRuleSet", "override_action": "none", "priority": 30, "rule_action_override": [], "vendor_name": "AWS" }, { "name": "AWSManagedRulesSQLiRuleSet", "override_action": "none", "priority": 40, "rule_action_override": [], "vendor_name": "AWS" }, { "name": "AWSManagedRulesLinuxRuleSet", "override_action": "none", "priority": 50, "rule_action_override": [], "vendor_name": "AWS" }, { "name": "AWSManagedRulesUnixRuleSet", "override_action": "none", "priority": 60, "rule_action_override": [], "vendor_name": "AWS" } ]``` | no |
| name | A friendly name of the WebACL. | `string` | n/a | yes |
| scope | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the WAFv2 ACL. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| web\_acl\_id | The ARN of the WAF WebACL. |
<!-- END_TF_DOCS -->

## Developer Setup

Install dependencies (macOS)

```shell
brew install pre-commit go terraform terraform-docs
pre-commit install --install-hooks
```
