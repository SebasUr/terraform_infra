resource "aws_lb" "this" {
  name               = "web-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_lb_id]
  subnets            = var.public_subnet_ids
  internal           = false
}

resource "aws_lb_target_group" "this" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
    matcher  = "200-399"
    interval = var.health_check_interval
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
