resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  #provider = "aws"
  tags {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "sn1" {
  availability_zone = "eu-central-1a"
  cidr_block        = "192.168.1.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_subnet" "sn2" {
  availability_zone = "eu-central-1b"
  cidr_block        = "192.168.2.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_subnet" "sn3" {
  availability_zone = "eu-central-1c"
  cidr_block        = "192.168.3.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_subnet" "sn4" {
  availability_zone = "eu-central-1a"
  cidr_block        = "192.168.4.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_subnet" "sn5" {
  availability_zone = "eu-central-1b"
  cidr_block        = "192.168.5.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_subnet" "sn6" {
  availability_zone = "eu-central-1c"
  cidr_block        = "192.168.6.0/24"
  #provider          = "aws"
  vpc_id            = "${aws_vpc.main.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "main"
  }
}

resource "aws_route_table_association" "a1" {
  subnet_id      = "${aws_subnet.sn1.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "a2" {
  subnet_id      = "${aws_subnet.sn2.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_route_table_association" "a3" {
  subnet_id      = "${aws_subnet.sn3.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_security_group" "icmp" {
  name        = "allow_icmp"
  description = "Allow icmp inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  tags {
    Name = "icmp"
  }
}

resource "aws_security_group_rule" "all_icmp_within_vpc" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.icmp.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["217.153.94.18/32"]
  security_group_id = "${aws_security_group.icmp.id}"
}

resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.icmp.id}"
}

