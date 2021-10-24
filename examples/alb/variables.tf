variable "test_name" {
  type = string
}

variable "vpc_azs" {
  type = list(string)
}

variable "fixed_response" {
  type = string
}

variable "enable_block_all_ips" {
  type = bool
}

variable "enable_ip_rate_limit" {
  type = bool
}

variable "enable_rate_limit_url_foo" {
  type = bool
}
