module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope = "REGIONAL"

  rate_based_rule = {
    name : "IP-rate-limit",
    priority : 55,
    action : "block",
    limit : 100
  }

}