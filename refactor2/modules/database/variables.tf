variable "cluster_identifier" {
  description = "Identifier for the Aurora cluster"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "drupal"
}

variable "master_username" {
  description = "Master username for the DB"
  type        = string
  default     = "drupal"
}

variable "master_password" {
  description = "Master password for the DB"
  type        = string
  sensitive   = true
}

variable "engine" {
  description = "Aurora engine"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Aurora engine version (optional). Leave null to use AWS default"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "Instance class for Aurora instances"
  type        = string
  default     = "db.t3.medium"
}

variable "subnet_ids" {
  description = "List of two private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for tagging and potential future references"
  type        = string
}

variable "sg_db_id" {
  description = "Security Group ID to attach to the Aurora cluster"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether instances are publicly accessible"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Days to retain backups (0 to disable)"
  type        = number
  default     = 1
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = false
}
