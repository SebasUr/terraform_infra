resource "aws_launch_template" "this" {
    name_prefix   = "web-lt-"
    image_id      = var.launch_template_ami
    instance_type = var.instance_type
    vpc_security_group_ids = [var.sg_web_id]
    key_name = var.key_name
    tag_specifications {
        resource_type = "instance"
        tags = { Name = "web-asg" }
    }
}

resource "aws_autoscaling_group" "this" {
    name                = "web-asg"
    max_size            = var.max_size
    min_size            = var.min_size
    desired_capacity    = var.desired_capacity
    vpc_zone_identifier = var.private_subnet_ids
    launch_template {
        id      = aws_launch_template.this.id
        version = "$Latest"
    }
    target_group_arns = [var.target_group_arn]
    health_check_type         = "ELB"
    health_check_grace_period = 300
    tag {
        key                 = "Name"
        value               = "web-asg"
        propagate_at_launch = true
    }
}
