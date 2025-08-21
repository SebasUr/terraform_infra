variable "public_subnet_ids" { type = list(string) }
variable "sg_lb_id" { type = string }
variable "vpc_id" { type = string }
variable "health_check_path" { type = string default = "/" }
variable "health_check_interval" { type = number default = 30 }
