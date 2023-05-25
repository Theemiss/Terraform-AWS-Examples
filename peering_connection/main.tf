resource "aws_vpc" "vpc_lab_test_1" {
  cidr_block           = var.vpc_cidr_block_1
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name_1
  }
  tags_all = {
    env = var.name_tag_value
  }
}

resource "aws_vpc" "vpc_lab_test_2" {
  cidr_block           = var.vpc_cidr_block_2
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name_2
  }
  tags_all = {
    env = var.name_tag_value
  }
}

resource "aws_vpc_peering_connection" "vpc1_to_vpc2" {
  vpc_id      = aws_vpc.vpc_lab_test_1.id
  peer_vpc_id = aws_vpc.vpc_lab_test_2.id
  auto_accept = true
  requester {
    allow_remote_vpc_dns_resolution = true
  }
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  tags = {
    Name = "${var.peering_connection_name}"
  }
  tags_all = {
    env = var.name_tag_value
  }
}
