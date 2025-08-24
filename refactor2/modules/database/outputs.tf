output "cluster_id" { value = aws_rds_cluster.aurora_cluster.id }
output "cluster_arn" { value = aws_rds_cluster.aurora_cluster.arn }
output "endpoint" { value = aws_rds_cluster.aurora_cluster.endpoint }
output "reader_endpoint" { value = aws_rds_cluster.aurora_cluster.reader_endpoint }
output "writer_instance_id" { value = aws_rds_cluster_instance.writer.id }
output "reader_instance_id" { value = aws_rds_cluster_instance.reader.id }
