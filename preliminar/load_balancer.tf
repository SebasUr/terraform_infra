# Application Load Balancer + Target Group

resource "aws_lb" "alb" {
  name                       = "TF-lb-WebCMS"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb.id]
  subnets                    = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  internal                   = false
  enable_deletion_protection = false
  tags                       = { Name = "TF_lb-WebCMS" }
}

resource "aws_lb_target_group" "tg" {
  name     = "TF-tg-CMS"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cms.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 300
    timeout             = 100
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = { Name = "TF_tg-CMS" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
