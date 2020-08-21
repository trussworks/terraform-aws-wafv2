module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope = "REGIONAL"
  filtered_header_rule = {
    header_types = ["test1", "test2"]
    header_value = "host"
    priority     = 1
  }
}