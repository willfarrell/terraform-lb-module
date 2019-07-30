resource "aws_lb" "main" {
  name = local.name
  internal = var.internal
  load_balancer_type = var.type
  #ip_address_type    = var.internal ? "ipv4" : "dualstack" #  You must specify subnets with an associated IPv6 CIDR block.

  subnets = var.subnet_ids

  security_groups = [
    aws_security_group.main.id,
  ]

  access_logs {
    bucket = local.logging_bucket
    prefix = "Logs/${local.account_id}/LB/${local.name}"
    enabled = true
  }

  tags = merge(
  local.tags,
  {
    Name = local.name
  }
  )
}

resource "aws_wafregional_web_acl_association" "main" {
  count = (var.waf_acl_id == "") ? 0 : 1
  resource_arn = aws_lb.main.arn
  web_acl_id = var.waf_acl_id
}

resource "aws_lb_target_group" "main" {
  count = length(local.ports_no_https)
  name = "${local.name}-target-group"
  vpc_id = var.vpc_id
  protocol = "HTTP"
  port = local.ports_no_https[count.index]

  health_check {
    enabled = var.health_check_enabled
    path = var.health_check_path
    interval = var.health_check_interval
    matcher = var.health_check_matcher
  }

  tags = merge(
  local.tags,
  {
    Name = local.name
  }
  )
}

resource "aws_security_group" "main" {
  name = "${local.name}-security-group"
  vpc_id = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags = merge(
  local.tags,
  {
    Name = local.name
    Description = "Access to the ${var.type} LB"
  }
  )
}

