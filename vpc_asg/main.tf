

resource "aws_vpc" "vpc_lab_test" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = {
    Name = var.name_tag_value
  }
}
resource "aws_subnet" "subnet_lab_test" {

  vpc_id            = aws_vpc.vpc_lab_test.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = var.name_tag_value
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
    Name = var.name_tag_value
  }
}
resource "aws_launch_configuration" "launch_config_lab_test" {
  name            = var.aws_launch_configuration_name
  image_id        = var.ami_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sg_lab_test.id]
  key_name        = var.ssh_key_name
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_lab_test" {
  name                 = var.aws_autoscaling_group_name
  launch_configuration = aws_launch_configuration.launch_config_lab_test.id
  min_size             = 1
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = [aws_subnet.subnet_lab_test.id]

  tag {
    key                 = "Name"
    value               = var.name_tag_value
    propagate_at_launch = true
  }
}

