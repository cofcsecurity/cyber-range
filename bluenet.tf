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

// Debian DNS
resource "aws_network_interface" "blue_dns_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.5"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_dns"
  }
}

resource "aws_instance" "blue_dns" {
  ami               = data.aws_ami.dns.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_dns_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue DNS"
  }
}

// Ubuntu Workstation
resource "aws_network_interface" "bluehost_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.20"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_bluehost"
  }
}

resource "aws_instance" "bluehost" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.bluehost_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Workstation"
  }
}

// Ubuntu MongoDB
resource "aws_network_interface" "blue_mongo_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.10"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_mongo"
  }
}

resource "aws_instance" "blue_mongo" {
  ami               = data.aws_ami.mongo.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_mongo_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Mongo"
  }
}

// Ubuntu Jenkins
resource "aws_network_interface" "blue_jenkins_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.30"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_jenkins"
  }
}

resource "aws_instance" "blue_jenkins" {
  ami               = data.aws_ami.jenkins.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_jenkins_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Jenkins"
  }
}
