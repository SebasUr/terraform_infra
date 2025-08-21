resource "aws_instance" "bastion" {
    ami                         = var.bastion_ami
    instance_type               = var.instance_type_bastion
    subnet_id                   = var.public_subnet_id
    associate_public_ip_address = true
    key_name                    = var.key_name
    vpc_security_group_ids      = [var.sg_bastion_id]
    tags = { Name = "bastion" }
}

resource "aws_instance" "db" {
    ami                         = var.db_ami
    instance_type               = var.instance_type_db
    subnet_id                   = var.db_subnet_id
    private_ip                  = var.db_private_ip
    associate_public_ip_address = false
    key_name                    = var.key_name
    vpc_security_group_ids      = [var.sg_db_id]
    tags = { Name = "db" }
}
