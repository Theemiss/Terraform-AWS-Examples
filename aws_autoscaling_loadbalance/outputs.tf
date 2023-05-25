output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.aws_lab_vpc.id
}
output "subnet_id_1" {
  description = "ID of the created subnet"
  value       = aws_subnet.aws_lab_subnet_1.id
}
output "aws_lab_subnet_2" {
  description = "ID of the created subnet"
  value       = aws_subnet.aws_lab_subnet_2.id
}

output "autoscaling_group_id" {
  description = "ID of the created EC2 instance"
  value       = aws_autoscaling_group.aws_lab_autoscaling_group.id
}
output "aws_launch_template" {
  description = "launch template"
  value       = aws_launch_template.aws_lab_launch_template.id
}
output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.aws_lab_security_group.id
}
output "aws_db_instance_id" {
  description = "ID of the created RDS instance"
  value       = aws_db_instance.aws_lab_db_instance.id
}
output "aws_db_subnet_group_id" {
  description = "ID of the created RDS subnet group"
  value       = aws_db_subnet_group.aws_lab_db_subnet_group.id
}
output "aws_db_instance_address" {
  description = "Address of the created RDS instance"
  value       = aws_db_instance.aws_lab_db_instance.address
}
output "aws_route_table_id" {
  description = "ID of the created route table"
  value       = aws_route_table.aws_lab_route_table.id
}
