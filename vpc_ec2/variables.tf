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
variable "secret_key" {
  description = "Secret key for the AWS account"
  type        = string
}
variable "access_key" {
  description = "Access key for the AWS account"
  type        = string
}

variable "subnet_name" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "ec2_name" {
  type = string
}
variable "sg_name" {
  type = string
}
