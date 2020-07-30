variable "name" {
  type        = string
  description = "A friendly name of the WebACL."
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."
}

variable "managed_rules" {
  type        = list(map(string))
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
