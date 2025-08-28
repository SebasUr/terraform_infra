# outputs.tf

output "vpc_id" {
  value = aws_vpc.cms.id
}
output "public_subnet_ids" {
  value = [aws_subnet.public_a.id, aws_subnet.public_b.id]
}
output "private_subnet_ids" {
  value = [aws_subnet.private_a1.id, aws_subnet.private_a2.id, aws_subnet.private_b1.id, aws_subnet.private_b2.id]
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "db_private_ip" {
  value = aws_instance.db.private_ip
}
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
}
