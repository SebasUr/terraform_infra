variable "region" { type = string default = "us-east-1" }
variable "key_name" { type = string default = "hi"}

variable "vpc_cidr" { type = string default = "172.16.0.0/16" }

variable "public_subnets" {
    type = list(object({ cidr = string, az = string }))
    default = [
        { cidr = "172.16.1.0/24", az = "us-east-1a" },
        { cidr = "172.16.4.0/24", az = "us-east-1b" }
        ]
}
variable "private_subnets" {
    type = list(object({ cidr = string, az = string }))
    default = [
        { cidr = "172.16.2.0/24", az = "us-east-1a" },
        { cidr = "172.16.3.0/24", az = "us-east-1a" },
        { cidr = "172.16.5.0/24", az = "us-east-1b" },
        { cidr = "172.16.6.0/24", az = "us-east-1b" }
    ]
}
variable "create_nat_gateways" { type = bool default = true }

variable "bastion_ami" { type = string default = "ami-020cba7c55df1f615" }
variable "db_ami" { type = string default = "ami-0b963a93fa7586845" }
variable "web_ami" { type = string default = "ami-065d2b6e6d37c58c1" }

variable "instance_type_bastion" { type = string default = "t2.micro" }
variable "instance_type_db" { type = string default = "t2.micro" }
variable "web_instance_type" { type = string default = "t2.small" }

variable "db_private_ip" { type = string default = "172.16.3.103" }

variable "web_min" { type = number default = 2 }
variable "web_max" { type = number default = 2 }
variable "web_desired" { type = number default = 2 }

variable "alb_health_check_path" { type = string default = "/" }
