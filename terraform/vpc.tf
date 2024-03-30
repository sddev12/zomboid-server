resource "aws_vpc" "zomboid_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.tags
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.zomboid_vpc.id

  tags = var.tags
}

resource "aws_eip" "eip" {
  tags = var.tags
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.zomboid_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = var.tags
}

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.zomboid_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = var.tags
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_subnet.id
}

resource "aws_security_group" "zomboid_vpc" {
  name        = "zomboid_server_sec_group"
  description = "Allow inbound traffic on 16261 and 16262 and allow all outbound traffic"
  vpc_id      = aws_vpc.zomboid_vpc.id

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_16261" {
  security_group_id = aws_security_group.zomboid_vpc.id
  cidr_ipv4         = aws_vpc.zomboid_vpc.cidr_block
  from_port         = 16261
  ip_protocol       = "udp"
  to_port           = 16261

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_16262" {
  security_group_id = aws_security_group.zomboid_vpc.id
  cidr_ipv4         = aws_vpc.zomboid_vpc.cidr_block
  from_port         = 16262
  ip_protocol       = "udp"
  to_port           = 16262

  tags = var.tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.zomboid_vpc.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = var.tags
}

