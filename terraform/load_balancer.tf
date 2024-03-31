resource "aws_lb" "nlb" {
  name               = "zomboid-server-nlb"
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.public.id
    allocation_id = aws_eip.eip.id
  }

  tags = var.tags
}

resource "aws_lb_listener" "port_16261" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "16261"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.zomboid_server_16261.arn
  }

  tags = var.tags
}

resource "aws_lb_listener" "port_16262" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "16262"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.zomboid_server_16262.arn
  }

  tags = var.tags
}

resource "aws_lb_target_group" "zomboid_server_16261" {
  name     = "zomboid-server-lb-tg-16261"
  port     = 16261
  protocol = "UDP"
  vpc_id   = aws_vpc.zomboid_vpc.id

  tags = var.tags
}

resource "aws_lb_target_group" "zomboid_server_16262" {
  name     = "zomboid-server-lb-tg-16262"
  port     = 16262
  protocol = "UDP"
  vpc_id   = aws_vpc.zomboid_vpc.id

  tags = var.tags
}
