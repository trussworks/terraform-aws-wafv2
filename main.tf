resource "aws_wafv2_web_acl" "main" {
  name  = var.name
  scope = var.scope

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = "${var.name}-metric"
  }

  dynamic "rule" {
    for_each = var.managed_rules
    content {
      name     = rule.value.name
      priority = rule.key # this will be the element index

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = rule.value.excluded_rules
            content {
              name = excluded_rule.value
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${rule.value.name}-metric"
        sampled_requests_enabled   = true
      }

    }
  }

  tags = var.tags

}

resource "aws_wafv2_web_acl_association" "main" {
  count = var.scope == "REGIONAL" && var.alb_arn != "" ? 1 : 0

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
