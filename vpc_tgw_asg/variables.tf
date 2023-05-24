variable "aws_region" {
  type = string
}
variable "ssh_key_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "security_group_description" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "name_tag_value" {
  type = string
}
variable "availability_zone" {
  type = string
}
variable "subnet_cidr_block" {
  type = string
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "route_table_name" {
  type = string
}
variable "route_cidr_block" {
  type = string
}
variable "aws_db_instance_name" {
  type = string
}
variable "aws_db_instance_class" {
  type = string
}
variable "aws_db_instance_engine" {
  type = string
}
variable "aws_db_instance_engine_version" {
  type = string
}
variable "aws_db_instance_username" {
  type = string
}
variable "aws_db_instance_password" {
  type = string
}
variable "aws_db_instance_allocated_storage" {
  type = string
}

variable "aws_db_subnet_group_name" {
  type = string
}
variable "aws_db_name" {
  type = string
}

variable "private_ips" {
  type = list(string)
}
variable "iam_role_name" {
  type = string

}
variable "security_group_name" {
  type = string
}
variable "transit_gateway_description" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "subnet_name" {
  type = string
}
variable "ec2_name" {
  type = string
}

variable "aws_autoscaling_group_name" {
  type = string
}
variable "aws_db_subnet_group_description" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}
variable "transit_gateway_route_table_name" {
  type = string
}
variable "transit_gateway_attachment_name" {
  type = string
}
variable "internet_gateway_name" {
  type = string
}
variable "db_availability_zone" {
  type = string
}