variable "name" {
  type        = string
  description = "A name to apply to this Web ACL."
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL"
}

variable "enable_common_rule_set" {
  type        = bool
  description = "Whether to include the AWS Managed Common Rule Set."
  default     = false
}

variable "count_common_rule_set" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed Common Rule Set."
  default     = false
}

variable "excluded_rules_common_rule_set" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed Common Rule Set."
  default     = []
}

variable "enable_ip_reputation_list" {
  type        = bool
  description = "Whether to include the AWS Managed IP Reputation List."
  default     = false
}

variable "count_ip_reputation_list" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed IP Reputation List."
  default     = false
}

variable "excluded_rules_ip_reputation_list" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed IP Reputation List."
  default     = []
}

variable "enable_known_bad_inputs" {
  type        = bool
  description = "Whether to include the AWS Managed Known Bad Inputs."
  default     = false
}

variable "count_known_bad_inputs" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed Known Bad Inputs."
  default     = false
}

variable "excluded_rules_known_bad_inputs" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed Known Bad Inputs."
  default     = []
}

variable "enable_sqli" {
  type        = bool
  description = "Whether to include the AWS Managed SQLi Rule Set."
  default     = false
}

variable "count_sqli" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed SQLi Rule Set."
  default     = false
}

variable "excluded_rules_sqli" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed SQLi Rule Set."
  default     = []
}

variable "enable_linux_os" {
  type        = bool
  description = "Whether to include the AWS Managed Linux OS Rule Set."
  default     = false
}

variable "count_linux_os" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed Linux OS Rule Set."
  default     = false
}

variable "excluded_rules_linux_os" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed Linux OS Rule Set."
  default     = []
}

variable "enable_posix" {
  type        = bool
  description = "Whether to include the AWS Managed POSIX Rule Set."
  default     = false
}

variable "count_posix" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed POSIX Rule Set."
  default     = false
}

variable "excluded_rules_posix" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed POSIX Rule Set."
  default     = []
}

variable "enable_anonymous_ip_list" {
  type        = bool
  description = "Whether to include the AWS Managed Anonymous IP List."
  default     = false
}

variable "count_anonymous_ip_list" {
  type        = bool
  description = "Whether to set the override action to count for the AWS Managed Anonymous IP List."
  default     = false
}

variable "excluded_rules_anonymous_ip_list" {
  type        = list(string)
  description = "List of rules to exclude from the AWS Managed Anonymous IP List."
  default     = []
}
