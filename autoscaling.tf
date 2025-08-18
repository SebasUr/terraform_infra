# Launch Template + Auto Scaling Group

resource "aws_launch_template" "web_template" {
  name_prefix   = "TF_template-WebCMS"
  image_id      = "ami-065d2b6e6d37c58c1" #"ami-0469b448e99c671ec"
  instance_type = "t2.small"

  vpc_security_group_ids = [aws_security_group.web.id]

  key_name = length(trimspace(var.key_name)) > 0 ? var.key_name : null

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "TF_template-WebCMS-instance" }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name             = "TF_ag-WebCMS"
  max_size         = 2
  min_size         = 2
  desired_capacity = 2

  vpc_zone_identifier = [aws_subnet.private_a1.id, aws_subnet.private_b1.id] # 172.16.2.0/24 & 172.16.5.0/24

  launch_template {
    id      = aws_launch_template.web_template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  enabled_metrics = ["GroupInServiceInstances", "GroupPendingInstances"]

  tag {
    key                 = "Name"
    value               = "TF_auto-WebCMS"
    propagate_at_launch = true
  }
}
