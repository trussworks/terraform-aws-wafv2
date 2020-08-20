module "wafv2" {
  source = "../../"
  name   = var.test_name

  scope   = "REGIONAL"
  alb_arn = aws_lb.alb.arn
}

resource "aws_lb" "alb" {
  name               = var.test_name
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"
  name    = var.test_name
  cidr    = "10.0.0.0/16"
  azs     = var.vpc_azs
  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]
}
