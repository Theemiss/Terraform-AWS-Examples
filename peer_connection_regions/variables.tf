variable "aws_region" {
  type = string
}


variable "name_tag_value" {
  type    = string
  default = "tekouin_test_labs"
}



variable "vpc_cidr_block_2" {
  type = string

}
variable "vpc_cidr_block_1" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "vpc_name_2" {
  type = string
}
variable "vpc_name_1" {
  type = string
}
variable "peer_region" {
  type = string
}
variable "peering_connection_name" {
  type    = string
  default = "vpc1_to_vpc2"
}

