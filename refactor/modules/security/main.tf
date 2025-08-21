resource "aws_security_group" "bastion" {
    name        = "sg-bastion"
    description = "SSH Bastion"
    vpc_id      = var.vpc_id
    ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
    egress  { from_port = 0  to_port = 0  protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_security_group" "lb" {
    name        = "sg-alb"
    description = "HTTP ALB"
    vpc_id      = var.vpc_id
    ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
    egress  { from_port = 0  to_port = 0  protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_security_group" "web" {
    name        = "sg-web"
    description = "Web instances"
    vpc_id      = var.vpc_id
    ingress {
        description     = "HTTP from ALB"
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        security_groups = [aws_security_group.lb.id]
    }
    ingress {
        description = "SSH from first public subnet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.public_subnet_cidrs[0]]
    }
    egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_security_group" "db" {
    name        = "sg-db"
    description = "DB access"
    vpc_id      = var.vpc_id
    ingress {
        description = "MySQL from first two private subnets"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = slice(var.private_subnet_cidrs, 0, 2)
    }
    ingress {
        description = "SSH from bastion public subnet"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.public_subnet_cidrs[0]]
    }
    egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}
