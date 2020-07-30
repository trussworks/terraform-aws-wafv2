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
    name           = string
    excluded_rules = list(string)
  }))
  description = "List of WAF rules."
  default = [
    {
      name           = "AWSManagedRulesCommonRuleSet",
      excluded_rules = []
    },
    {
      name           = "AWSManagedRulesAmazonIpReputationList",
      excluded_rules = []
    },
    {
      name           = "AWSManagedRulesKnownBadInputsRuleSet",
      excluded_rules = []
    },
    {
      name           = "AWSManagedRulesSQLiRuleSet",
      excluded_rules = []
    },
    {
      name           = "AWSManagedRulesLinuxRuleSet",
      excluded_rules = []
    },
    {
      name           = "AWSManagedRulesUnixRuleSet",
      excluded_rules = []
    }
  ]
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the bucket."
  default     = {}
}

variable "alb_arn" {
  type        = string
  description = "ARN of the Application Load Balancer (ALB) to be associated with the Web Application Firewall (WAF) Access Control List (ACL)."
  default     = ""
}
