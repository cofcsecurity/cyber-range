# Notes: PLEASE DO NOT CHANGE IP ADDRESSES AS THIS WILL BREAK SERVICES 
# Most services are preconfigured with the ip addresses already so if you change the webserver
# or database IP's it will break things.  


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


// start of images primary CORE images

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

// Ubuntu WebServer
resource "aws_network_interface" "blue_web_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.10"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_web"
  }
}

resource "aws_instance" "blue_web" {
  ami               = data.aws_ami.ubuntu-django.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_web_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Webserver"
  }
}

// CentOS Database
resource "aws_network_interface" "blue_CODB_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.20"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_codb"
  }
}

resource "aws_instance" "blue_CODB" {
  ami               = data.aws_ami.centos-db.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_CODB_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue CentOS DB"
  }
}

// CentOS Samba Fileshare
resource "aws_network_interface" "blue_COS_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.30"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_cos"
  }
}

resource "aws_instance" "blue_centos_samba" {
  ami               = data.aws_ami.centos-samba.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_COS_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue CentOS Samba"
  }
}


// Windows Active Directory
resource "aws_network_interface" "blue_win_ad_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.60"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_win_ad"
  }

}

resource "aws_instance" "blue_windows_ad" {
  ami               = data.aws_ami.windows-ad.id
  instance_type     = "t3.medium"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_win_ad_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Windows AD"
  }
}

resource "aws_network_interface" "blue_win_db_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.50"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_windows-1"
  }

}

resource "aws_instance" "blue_windows_db" {
  ami               = data.aws_ami.windows-db.id
  instance_type     = "t3.small"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_win_db_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Windows DB"
  }
}

// Ubuntu Mail Server
resource "aws_network_interface" "blue_mail_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.40"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_mail"
  }
}

resource "aws_instance" "blue_ubuntu_mail" {
  ami               = data.aws_ami.ubuntu-email.id
  instance_type     = "t3.small"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_mail_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Ubuntu Mail"
  }
}

// empty DB server
resource "aws_network_interface" "blue_ubuntu_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.80"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_ubuntu"
  }
}

resource "aws_instance" "blue_ubuntu" {
  ami               = data.aws_ami.mongo.id
  instance_type     = "t3.micro"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.blue_ubuntu_nic.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Ubuntu"
  }
}


// shadow team memeber machines are listed below. More can be added as needed

resource "aws_network_interface" "ws1" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.15"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_windows-1"
  }

}

resource "aws_instance" "windows-server-1" {
  ami               = data.aws_ami.windows-db.id
  instance_type     = "t3.small"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.ws1.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Windows 1"
  }

}


resource "aws_network_interface" "ws2" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.25"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_blue_windows-1"
  }

}

resource "aws_instance" "windows-server-2" {
  ami               = data.aws_ami.windows-db.id
  instance_type     = "t3.small"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.ws2.id
    device_index         = 0
  }

  tags = {
    "Name" = "Blue Windows 2"
  }

}


