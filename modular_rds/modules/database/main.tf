# DB Subnet Group covering two private subnets (across two AZs)
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet-group"
  description = "Subnet group for Aurora"
  subnet_ids  = var.subnet_ids
  tags = {
    Name = "db-subnet-group"
  }
}

# Aurora Cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.db_name
  master_username         = var.master_username
  master_password         = var.master_password
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.sg_db_id]
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  storage_encrypted       = var.storage_encrypted
  apply_immediately       = var.apply_immediately

  # Disable autoscaling on serverless; we are using provisioned instances
  engine_mode = "provisioned"

  tags = {
    Name = var.cluster_identifier
  }
}

# Writer instance
resource "aws_rds_cluster_instance" "writer" {
  identifier          = "${var.cluster_identifier}-1"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = var.publicly_accessible
  apply_immediately   = var.apply_immediately
}

# Reader instance in another AZ (AWS will distribute across subnets)
resource "aws_rds_cluster_instance" "reader" {
  identifier          = "${var.cluster_identifier}-2"
  cluster_identifier  = aws_rds_cluster.aurora_cluster.id
  instance_class      = var.instance_class
  engine              = aws_rds_cluster.aurora_cluster.engine
  engine_version      = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible = var.publicly_accessible
  apply_immediately   = var.apply_immediately
}
