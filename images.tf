data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-ubuntu-workstation"]
  }
}

data "aws_ami" "kali" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["red-kali"]
  }
}

data "aws_ami" "dns" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-debian-dnsmasq"]
  }
}

data "aws_ami" "mongo" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-ubuntu-mongodb"]
  }
}

data "aws_ami" "jenkins" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["blue-ubuntu-jenkins"]
  }
}


data "aws_ami" "windows" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["blue-windows2022"]
  }
}

data "aws_ami" "windows-ad" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["import-ami-0f808d07ca3fa3e2c"]
  }
}

data "aws_ami" "windows-db" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["import-ami-02c9d05d585fe5474"]
  }
}

data "aws_ami" "ubuntu-django" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["blue-ubuntu-django"]
  }
}

data "aws_ami" "centos-samba" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["blue-centOS-samba"]
  }
}

data "aws_ami" "centos-db" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["blue-centOS-mysql"]
  }
}

data "aws_ami" "ubuntu-email" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["blue-ubuntu-email"]
  }
}