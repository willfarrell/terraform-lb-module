resource "aws_autoscaling_attachment" "ecs" {
  count                  = length(local.ports_no_https)
  autoscaling_group_name = var.autoscaling_group_name
  alb_target_group_arn   = aws_lb_target_group.main[count.index].arn
}

resource "aws_security_group_rule" "ecs_access" {
  count                    = length(local.ports_no_https)
  security_group_id        = var.security_group_id
  type                     = "ingress"
  from_port                = local.ports_no_https[count.index]
  to_port                  = local.ports_no_https[count.index]
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main.id
}
