
# Create a VPC
resource "aws_vpc" "aws_lab_vpc" {
  cidr_block = "10.0.0.0/16"


  tags = {
    Name = var.vpc_name
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "aws_lab_subnet_1" {
  vpc_id            = aws_vpc.aws_lab_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = var.subnet_name
  }
}
resource "aws_subnet" "aws_lab_subnet_2" {
  vpc_id            = aws_vpc.aws_lab_vpc.id
  cidr_block        = var.subnet_cidr_block_2
  availability_zone = var.db_availability_zone
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "aws_lab_internet_gateway" {
  vpc_id = aws_vpc.aws_lab_vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

# Create a route table and associate it with the VPC
resource "aws_route_table" "aws_lab_route_table" {
  vpc_id = aws_vpc.aws_lab_vpc.id

  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.aws_lab_internet_gateway.id
  }

  tags = {
    Name = var.route_table_name
  }
}

# Create a Transit Gateway
resource "aws_ec2_transit_gateway" "aws_lab_transit_gateway" {

  description = var.transit_gateway_description
}

# Create a Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "aws_lab_attachment" {
  subnet_ids         = [aws_subnet.aws_lab_subnet_1.id]
  transit_gateway_id = aws_ec2_transit_gateway.aws_lab_transit_gateway.id
  vpc_id             = aws_vpc.aws_lab_vpc.id
  tags = {
    Name = var.transit_gateway_attachment_name
  }
}

# Create a Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "aws_lab_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.aws_lab_transit_gateway.id

  tags = {
    Name = var.transit_gateway_route_table_name
  }
}

# Create a Transit Gateway Route
resource "aws_ec2_transit_gateway_route" "aws_lab_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.aws_lab_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.aws_lab_attachment.id

  depends_on = [aws_ec2_transit_gateway_route_table.aws_lab_route_table]
}

# Create a security group for the EC2 instance
resource "aws_security_group" "aws_lab_security_group" {
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = aws_vpc.aws_lab_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add additional ingress rules as needed for your application

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an IAM role for the EC2 instance
resource "aws_iam_instance_profile" "aws_lab_instance_profile" {
  name = var.iam_instance_profile_name

  role = aws_iam_role.aws_lab_role.name
}

# Create an IAM role for the EC2 instance
resource "aws_iam_role" "aws_lab_role" {
  name = var.iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_instance" "aws_lab_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile = aws_iam_instance_profile.aws_lab_instance_profile.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.aws_lab_network_interface.id
  }

  # Additional configurations for the EC2 instance can be added here
}
resource "aws_network_interface" "aws_lab_network_interface" {
  subnet_id   = aws_subnet.aws_lab_subnet_1.id
  private_ips = var.private_ips

}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "aws_lab_autoscaling_group" {
  name             = "aws_lab-autoscaling-group"
  min_size         = 1
  max_size         = 5
  desired_capacity = 2
  launch_template {
    id      = aws_launch_template.aws_lab_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.aws_lab_subnet_1.id]
}

resource "aws_launch_template" "aws_lab_launch_template" {
  name_prefix   = "aws_lab-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    device_index                = 0
    subnet_id                   = aws_subnet.aws_lab_subnet_1.id
  }

}

resource "aws_db_instance" "aws_lab_db_instance" {
  allocated_storage    = 20
  engine               = var.aws_db_instance_engine
  engine_version       = var.aws_db_instance_engine_version
  instance_class       = var.aws_db_instance_class
  db_name              = var.aws_db_name
  username             = var.aws_db_instance_username
  password             = var.aws_db_instance_password
  db_subnet_group_name = aws_db_subnet_group.aws_lab_db_subnet_group.name
  availability_zone    = var.db_availability_zone
  skip_final_snapshot  = true # don't snapshot when instance is destroyed (so we are able to destroy it)

}

resource "aws_db_subnet_group" "aws_lab_db_subnet_group" {
  name = var.aws_db_subnet_group_name

  subnet_ids  = [aws_subnet.aws_lab_subnet_1.id, aws_subnet.aws_lab_subnet_2.id]
  description = var.aws_db_subnet_group_description
}

resource "aws_security_group" "aws_lab_security_group" {
  name        = "aws_lab_security_group"
  description = "aws_lab_security_group"
  vpc_id      = aws_vpc.aws_lab_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [""]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [""]
  }
  tags = {
    Name = "aws_lab_security_group"
  }
}


resource "aws_lb" "aws_lab_lb" {
  name                       = "aws_lab_lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.aws_lab_security_group.id]
  subnets                    = [aws_subnet.aws_lab_subnet_1.id, aws_subnet.aws_lab_subnet_2.id]
  enable_deletion_protection = false
  tags = {
    Name = "aws_lab_lb"
  }
}
