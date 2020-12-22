variable "test_name" {
  type = string
}

variable "vpc_azs" {
  type = list(string)
}

variable "fixed_response" {
  type = string
}

variable "block_all_ips" {
  type = bool
}
