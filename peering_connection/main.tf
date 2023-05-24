

resource "aws_vpc" "vpc_lab_test_1" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name_1
  }
}
resource "aws_vpc" "vpc_lab_test_2" {
  cidr_block = var.vpc_cidr_block

  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name_2
  }
}
resource "aws_vpc_peering_connection" "vpc2_to_vpc1" {
  vpc_id      = aws_vpc.vpc_lab_test_1.id
  peer_vpc_id = aws_vpc.vpc_lab_test_2.id
  peer_region = var.peer_region
  auto_accept = true

  tags = {
    Name = "VPC Peering: VPC 1 to VPC 2"
  }
}

resource "aws_route" "vpc1_to_vpc2_route" {
  route_table_id            = aws_vpc.vpc_lab_test_1.default_route_table_id
  destination_cidr_block    = aws_vpc.vpc_lab_test_2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
}

resource "aws_route" "vpc2_to_vpc1_route" {
  route_table_id            = aws_vpc.vpc_lab_test_1.default_route_table_id
  destination_cidr_block    = aws_vpc.vpc_lab_test_2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc2_to_vpc1.id
}
