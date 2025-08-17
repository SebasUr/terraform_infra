# Security Groups

# Bastion SG
resource "aws_security_group" "bastion" {
  name        = "TF_SG-BastionHost"
  description = "Enable SSH Access"
  vpc_id      = aws_vpc.cms.id

  ingress {
    description = "Allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "TF_SG-BastionHost" }
}

# DB SG
resource "aws_security_group" "db" {
  name        = "TF_SG-DB-CMS"
  description = "Allow SQL Access"
  vpc_id      = aws_vpc.cms.id

  # MySQL/Aurora from private subnets (two subnets)
  ingress {
    description = "Allow connections to the DB from private-a1"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_a1.cidr_block]
  }
  ingress {
    description = "Allow connections to the DB from private-b1"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private_b1.cidr_block]
  }
  # SSH from public-a (bastion)
  ingress {
    description = "Allow ssh traffic from public-a"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_a.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "TF_SG-DB-CMS" }
}

# Web SG
resource "aws_security_group" "web" {
  name        = "TF_SG-WebCMS"
  description = "Enable HTTP Access"
  vpc_id      = aws_vpc.cms.id

  # Allow HTTP from the Load Balancer security group (this allows ALB health checks and traffic reach the web instances)
  ingress {
    description     = "Permit HTTP from the load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }
  # SSH from public-a
  ingress {
    description = "Permit ssh connections from public-a"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_a.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "TF_SG-WebCMS" }
}

# Load Balancer SG (allows HTTP)
resource "aws_security_group" "lb" {
  name        = "TF_SG-LB"
  description = "Allow HTTP from anywhere"
  vpc_id      = aws_vpc.cms.id

  ingress {
    description = "Allow HTTP IPv4"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "TF_SG-LB" }
}
