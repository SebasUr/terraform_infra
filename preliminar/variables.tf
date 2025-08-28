variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "session_token" {
  description = "AWS session token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name to use for instances"
  default     = "hi"
}

variable "ubuntu_ami" {
  type        = string
  description = "latest Ubuntu 22.04 LTS AMI will be used."
  default     = "ami-020cba7c55df1f615"
}