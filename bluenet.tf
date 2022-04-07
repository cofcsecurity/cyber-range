resource "aws_subnet" "blue_subnet" {
  vpc_id            = aws_vpc.range.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.aws_availability_zone
}

resource "aws_route_table" "blue_routes" {
  vpc_id = aws_vpc.range.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bastion_nat_gateway.id
  }
}

resource "aws_route_table_association" "blue_routes" {
  subnet_id      = aws_subnet.blue_subnet.id
  route_table_id = aws_route_table.blue_routes.id
}

resource "aws_network_acl" "blue_subnet_acl" {
  vpc_id     = aws_vpc.range.id
  subnet_ids = [aws_subnet.blue_subnet.id]

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    rule_no    = 100
  }
}

resource "aws_network_interface" "blue_one_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.10"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_one"
  }
}

resource "aws_instance" "blue_one" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_one_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue One"
  }
}

resource "aws_network_interface" "blue_two_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.20"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_two"
  }
}

resource "aws_instance" "blue_two" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_two_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Two"
  }
}

resource "aws_network_interface" "blue_three_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.30"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_three"
  }
}

resource "aws_instance" "blue_three" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_three_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Three"
  }
}

resource "aws_network_interface" "blue_four_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.40"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_four"
  }
}

resource "aws_instance" "blue_four" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_four_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Four"
  }
}

resource "aws_network_interface" "blue_five_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.50"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_five"
  }
}

resource "aws_instance" "blue_five" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_five_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Five"
  }
}

resource "aws_network_interface" "blue_six_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.60"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_six"
  }
}

resource "aws_instance" "blue_six" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_six_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Six"
  }
}

resource "aws_network_interface" "blue_seven_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.70"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_seven"
  }
}

resource "aws_instance" "blue_seven" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_seven_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Seven"
  }
}

resource "aws_network_interface" "blue_eight_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.80"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_eight"
  }
}

resource "aws_instance" "blue_eight" {
  ami               = data.aws_ami.practice.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_eight_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Eight"
  }
}
