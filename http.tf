# HTTP
resource "aws_lb_listener" "port_forward" {
  count             = var.https_only ? 0 : length(var.ports)
  load_balancer_arn = aws_lb.main.arn
  protocol          = "HTTP"
  port              = var.ports[count.index]

  default_action {
    target_group_arn = aws_lb_target_group.main[count.index].arn
    type             = "forward"
  }
}

resource "aws_security_group_rule" "port" {
  count             = length(var.ports)
  security_group_id = aws_security_group.main.id

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  type      = "ingress"
  protocol  = "tcp"
  to_port   = var.ports[count.index]
  from_port = var.ports[count.index]
}

