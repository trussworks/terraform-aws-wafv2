resource "aws_wafv2_ip_set" "block_all_ips" {
  name = "block-all-ips-${var.test_name}"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  # generates a list of all /8s
  addresses = formatlist("%s.0.0.0/8", range(0, 256))
}

resource "aws_wafv2_ip_set" "ipset" {
  name = "ip_set_${var.test_name}"

  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "1.2.3.4/32",
    "5.6.7.8/32"
  ]
}

module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope         = "REGIONAL"
  associate_alb = true
  alb_arn       = aws_lb.alb.arn

  filtered_header_rule = {
    header_types = [
      "test1",
      "test2"
    ]
    header_value = "host"
    priority     = 1
    action       = "allow"
  }

  ip_sets_rule = [
    {
      name       = var.test_name
      priority   = 5
      action     = "count"
      ip_set_arn = aws_wafv2_ip_set.ipset.arn
    },
    {
      name       = "block-all-ips"
      priority   = 6
      action     = var.enable_block_all_ips ? "block" : "count"
      ip_set_arn = aws_wafv2_ip_set.block_all_ips.arn
    }
  ]

  ip_rate_based_rule = {
    name : "ip-rate-limit",
    priority : 7,
    action : var.enable_ip_rate_limit ? "block" : "count",
    limit : 100
  }

  ip_rate_url_based_rules = [
    {
      name : "ip-rate-foo-limit",
      priority : 8,
      action : var.enable_rate_limit_url_foo ? "block" : "count",
      limit : 100,
      search_string : "/foo/",
      positional_constraint : "STARTS_WITH"
    },
    {
      name : "ip-rate-bar-limit",
      priority : 9,
      action : "block",
      search_string : "/bar/",
      positional_constraint : "STARTS_WITH"
      limit : 200
    }
  ]

  group_rules = [
    {
      excluded_rules : [],
      name : aws_wafv2_rule_group.block_countries.name,
      arn : aws_wafv2_rule_group.block_countries.arn,
      override_action : "none",
      priority : 11
    }
  ]
}

#
# ALB
#

resource "aws_lb" "alb" {
  name               = var.test_name
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.lb_sg.id]

  timeouts {
    create = "30m"
  }
}

resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = var.fixed_response
      status_code  = "200"
    }
  }

}

resource "aws_security_group" "lb_sg" {
  name   = "lb-${var.test_name}"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "app_lb_allow_outbound" {
  security_group_id = aws_security_group.lb_sg.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_lb_allow_all_http" {
  security_group_id = aws_security_group.lb_sg.id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#
# VPC
#

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name = var.test_name
  cidr = "10.0.0.0/16"
  azs  = var.vpc_azs
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}

#
# WAFv2 Rule Group
#

resource "aws_wafv2_rule_group" "block_countries" {
  name     = "rule_group_${var.test_name}"
  scope    = "REGIONAL"
  capacity = 1

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {

      geo_match_statement {
        country_codes = ["UA"]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
