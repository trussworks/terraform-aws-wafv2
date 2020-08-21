resource "aws_wafv2_ip_set" "ipset" {
  name = "ip_set_${var.test_name}1"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "1.2.3.4/32",
    "5.6.7.8/32"
  ]
}

resource "aws_wafv2_ip_set" "ipset2" {
  name = "ip_set_${var.test_name}2"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "9.10.11.12/32",
    "12.14.15.16/32"
  ]
}

module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope = "REGIONAL"

  blocked_ip_sets = [
    {
      name       = "ip_set_${var.test_name}1"
      priority   = 1
      ip_set_arn = aws_wafv2_ip_set.ipset.arn
    },
    {
      name       = "ip_set_${var.test_name}2"
      priority   = 2
      ip_set_arn = aws_wafv2_ip_set.ipset.arn
    }

  ]
}

