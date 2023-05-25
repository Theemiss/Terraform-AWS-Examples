

resource "aws_vpc" "vpc_lab_test" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "subnet_lab_test" {

  vpc_id            = aws_vpc.vpc_lab_test.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_name
  }
}
resource "aws_security_group" "sg_lab_test" {
  name        = var.sg_name
  description = var.security_group_description
  vpc_id      = aws_vpc.vpc_lab_test.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.sg_name
  }
}

resource "aws_instance" "ec2_lab_test" {

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key_name
  subnet_id                   = aws_subnet.subnet_lab_test.id
  vpc_security_group_ids      = [aws_security_group.sg_lab_test.id]
  associate_public_ip_address = true
  availability_zone           = var.availability_zone
  tenancy                     = "default"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    key_name = var.ssh_key_name
    host     = self.public_ip
  }
  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  lifecycle {
    create_before_destroy = true
  }
  monitoring = true
  count      = var.ec2_count

  tags = {
    Name = var.ec2_name
  }
}
