# resource "aws_subnet" "red_subnet" {
#   vpc_id            = aws_vpc.range.id
#   cidr_block        = "10.0.30.0/24"
#   availability_zone = var.aws_availability_zone
# }

# resource "aws_route_table" "red_routes" {
#   vpc_id = aws_vpc.range.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.bastion_nat_gateway.id
#   }
# }

# resource "aws_route_table_association" "red_routes" {
#   subnet_id      = aws_subnet.red_subnet.id
#   route_table_id = aws_route_table.red_routes.id
# }

# resource "aws_network_acl" "red_subnet_acl" {
#   vpc_id     = aws_vpc.range.id
#   subnet_ids = [aws_subnet.red_subnet.id]

#   ingress {
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#     protocol   = "-1"
#     rule_no    = 100
#   }

#   egress {
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#     protocol   = "-1"
#     rule_no    = 100
#   }
# }

# resource "aws_network_interface" "kalione_nic" {
#   subnet_id       = aws_subnet.red_subnet.id
#   private_ips     = ["10.0.30.10"]
#   security_groups = [aws_security_group.range_default_sg.id]

#   tags = {
#     Name = "range_kalione"
#   }
# }

# resource "aws_instance" "kalione" {
#   ami               = data.aws_ami.kali.id
#   instance_type     = "t2.micro"
#   availability_zone = var.aws_availability_zone
#   key_name          = aws_key_pair.range_ssh_public_key.key_name

#   network_interface {
#     network_interface_id = aws_network_interface.kalione_nic.id
#     device_index         = 0
#   }

#   tags = {
#     "Name" = "Kali One"
#   }
# }
