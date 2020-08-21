module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope = "REGIONAL"
  filtered_header_rule = {
    names = ["test1", "test2"]
    filter_header = "host"
    priority = 1
  }
}