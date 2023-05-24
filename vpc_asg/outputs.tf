output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.vpc_lab_test.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.subnet_lab_test.id
}

output "autoscaling_group_id" {
  description = "ID of the created EC2 instance"
  value       = aws_autoscaling_group.autoscaling_lab_test.id
}
output "launch_configuration_id" {
  description = "ID of the created EC2 instance"
  value       = aws_launch_configuration.launch_config_lab_test.id
}
output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.sg_lab_test.id
}
