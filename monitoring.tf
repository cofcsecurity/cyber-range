# Security Onion (Zeek/Suricata/Elasticsearch) for network detection over
# blue_subnet. AWS doesn't do passive/promiscuous packet capture like a
# physical span port - a second NIC alone would see nothing. Real capture
# requires VPC Traffic Mirroring: a mirror session per source ENI, targeting
# Security Onion's dedicated monitor NIC.
#
# Sizing note: Security Onion's own docs put a standalone install at 4 vCPU /
# 12GB minimum, more for production. t3.xlarge below is a starting point for
# ~10 monitored hosts, not a verified number - watch it under real load and
# resize if the indexer falls behind.
#
# Scope note: this box currently sits in blue_subnet on the same allow-all
# security group as everything else, so it's reachable the same way any
# other blue host is. True isolation (own subnet, no red/blue access to the
# management NIC) depends on the default-deny SG/NACL work and possibly a
# dedicated white/monitoring subnet - both separate backlog items.

resource "aws_network_interface" "security_onion_mgmt_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.90"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_security_onion_mgmt"
  }
}

# Traffic mirroring delivers mirrored packets over VXLAN (UDP/4789) to this
# NIC's IP - it isn't a passive tap, it's a real destination that receives
# encapsulated traffic.
resource "aws_network_interface" "security_onion_monitor_nic" {
  subnet_id       = aws_subnet.blue_subnet.id
  private_ips     = ["10.0.10.91"]
  security_groups = [aws_security_group.range_default_sg.id]

  tags = {
    Name = "range_security_onion_monitor"
  }
}

resource "aws_instance" "security_onion" {
  ami               = data.aws_ami.security-onion.id
  instance_type     = "t3.xlarge"
  availability_zone = var.aws_availability_zone
  key_name          = aws_key_pair.range_ssh_public_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.security_onion_mgmt_nic.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.security_onion_monitor_nic.id
    device_index         = 1
  }

  tags = {
    "Name" = "Security Onion"
  }
}

resource "aws_ec2_traffic_mirror_target" "security_onion" {
  network_interface_id = aws_network_interface.security_onion_monitor_nic.id
  description          = "Security Onion monitor NIC"
}

resource "aws_ec2_traffic_mirror_filter" "mirror_all" {
  description      = "Mirror all IPv4 traffic to Security Onion"
  network_services = []
}

resource "aws_ec2_traffic_mirror_filter_rule" "mirror_all_ingress" {
  description              = "Accept all ingress"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.mirror_all.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 100
  rule_action              = "accept"
  traffic_direction        = "ingress"
}

resource "aws_ec2_traffic_mirror_filter_rule" "mirror_all_egress" {
  description              = "Accept all egress"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.mirror_all.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 100
  rule_action              = "accept"
  traffic_direction        = "egress"
}

# One mirror session per blue_subnet host we want Security Onion to see.
# Deliberately scoped to blue_subnet only - blue's SIEM watches blue's own
# network, the same as it would in a real SECCDC environment. Add new hosts
# here as they're added to bluenet.tf.
locals {
  blue_monitored_nics = {
    blue_dns    = aws_network_interface.blue_dns_nic.id
    blue_web    = aws_network_interface.blue_web_nic.id
    blue_codb   = aws_network_interface.blue_CODB_nic.id
    blue_samba  = aws_network_interface.blue_COS_nic.id
    blue_win_ad = aws_network_interface.blue_win_ad_nic.id
    blue_win_db = aws_network_interface.blue_win_db_nic.id
    blue_mail   = aws_network_interface.blue_mail_nic.id
    blue_ubuntu = aws_network_interface.blue_ubuntu_nic.id
    windows_ws1 = aws_network_interface.ws1.id
    windows_ws2 = aws_network_interface.ws2.id
  }
}

resource "aws_ec2_traffic_mirror_session" "blue_hosts" {
  for_each = local.blue_monitored_nics

  description              = "Mirror ${each.key} to Security Onion"
  network_interface_id     = each.value
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.security_onion.id
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.mirror_all.id
  session_number           = 1
}
