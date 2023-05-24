output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.vpc_lab_test.id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.subnet_lab_test.id
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2_lab_test.id
}

output "instance_public_ip" {
  description = "Public IP address of the created EC2 instance"
  value       = aws_instance.ec2_lab_test.public_ip
}
output "security_group_id" {
  description = "ID of the created security group"
  value       = aws_security_group.sg_lab_test.id
}
