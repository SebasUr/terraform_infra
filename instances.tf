# EC2: Bastion host
resource "aws_instance" "bastion" {
  ami                         = var.ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name                    = length(trimspace(var.key_name)) > 0 ? var.key_name : null
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = { Name = "TF_i-BastionHost" }
}

# Database server (private)
resource "aws_instance" "db" {
  ami                         = "ami-0b963a93fa7586845" # Own DB AMI ami-0dfec82a89aed24c1
  instance_type               = "t2.micro"
  private_ip                  = "172.16.3.103"
  subnet_id                   = aws_subnet.private_a2.id # private2-us-east-1a (172.16.3.0/24)
  associate_public_ip_address = false
  key_name                    = length(trimspace(var.key_name)) > 0 ? var.key_name : null
  vpc_security_group_ids      = [aws_security_group.db.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  tags = { Name = "TF_i-DB" }
}