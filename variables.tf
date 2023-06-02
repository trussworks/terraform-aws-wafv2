variable "name" {
  type        = string
  description = "A friendly name of the WebACL."
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."
}

variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    vendor_name     = string
    version         = optional(string)
    rule_action_override = list(object({
      name          = string
      action_to_use = string
    }))
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name                 = "AWSManagedRulesCommonRuleSet",
      priority             = 10
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    },
    {
      name                 = "AWSManagedRulesAmazonIpReputationList",
      priority             = 20
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    },
    {
      name                 = "AWSManagedRulesKnownBadInputsRuleSet",
      priority             = 30
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    },
    {
      name                 = "AWSManagedRulesSQLiRuleSet",
      priority             = 40
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    },
    {
      name                 = "AWSManagedRulesLinuxRuleSet",
      priority             = 50
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    },
    {
      name                 = "AWSManagedRulesUnixRuleSet",
      priority             = 60
      override_action      = "none"
      vendor_name          = "AWS"
      rule_action_override = []
    }
  ]
}

variable "ip_sets_rule" {
  type = list(object({
    name          = string
    priority      = number
    ip_set_arn    = string
    action        = string
    response_code = optional(number, 403)
  }))
  description = "A rule to detect web requests coming from particular IP addresses or address ranges."
  default     = []
}

variable "ip_rate_based_rule" {
  type = object({
    name          = string
    priority      = number
    limit         = number
    action        = string
    response_code = optional(number, 403)
  })
  description = "A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  default     = null
}

variable "ip_rate_url_based_rules" {
  type = list(object({
    name                  = string
    priority              = number
    limit                 = number
    action                = string
    response_code         = optional(number, 403)
    search_string         = string
    positional_constraint = string
  }))
  description = "A rate and url based rules tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  default     = []
}

variable "filtered_header_rule" {
  type = object({
    header_types  = list(string)
    priority      = number
    header_value  = string
    action        = string
    search_string = string
  })
  description = "HTTP header to filter . Currently supports a single header type and multiple header values."
  default = {
    header_types  = []
    priority      = 1
    header_value  = ""
    action        = "block"
    search_string = ""
  }
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the WAFv2 ACL."
  default     = {}
}

variable "associate_alb" {
  type        = bool
  description = "Whether to associate an ALB with the WAFv2 ACL."
  default     = false
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

variable "enable_logging" {
  type        = bool
  description = "Whether to associate Logging resource with the WAFv2 ACL."
  default     = false
}

variable "log_destination_arns" {
  type        = list(string)
  description = "The Amazon Kinesis Data Firehose, Cloudwatch Log log group, or S3 bucket Amazon Resource Names (ARNs) that you want to associate with the web ACL."
  default     = []
}

variable "group_rules" {
  type = list(object({
    name            = string
    arn             = string
    priority        = number
    override_action = string
  }))
  description = "List of WAFv2 Rule Groups."
  default     = []
}

variable "default_action" {
  type        = string
  description = "The action to perform if none of the rules contained in the WebACL match."
  default     = "allow"
}
