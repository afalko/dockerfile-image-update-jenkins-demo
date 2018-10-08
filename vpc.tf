resource "aws_vpc" "jenkins" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "jenkins" {
  vpc_id = "${aws_vpc.jenkins.id}"
}

resource "aws_subnet" "jenkins-master" {
  vpc_id            = "${aws_vpc.jenkins.id}"
  cidr_block        = "10.0.2.0/28"
  availability_zone = "${var.az}"
}

resource "aws_security_group" "jenkins-master" {
  vpc_id = "${aws_vpc.jenkins.id}"
  name   = "jenkins"

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "108.245.190.199/32",
    ]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${aws_subnet.jenkins-master.cidr_block}",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "TCP"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_subnet" "jenkins-nodes" {
  vpc_id            = "${aws_vpc.jenkins.id}"
  cidr_block        = "10.0.4.0/28"
  availability_zone = "${var.az}"
}

resource "aws_security_group" "jenkins-nodes" {
  name   = "jenkins-nodes"
  vpc_id = "${aws_vpc.jenkins.id}"

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "${aws_subnet.jenkins-master.cidr_block}",
    ]
  }
}

resource "aws_route_table" "jenkins-vpc-egress-ingress" {
  vpc_id = "${aws_vpc.jenkins.id}"

  route {
    gateway_id = "${aws_internet_gateway.jenkins.id}"
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_main_route_table_association" "jenkins-vpc-egress-ingress" {
  route_table_id = "${aws_route_table.jenkins-vpc-egress-ingress.id}"
  vpc_id         = "${aws_vpc.jenkins.id}"
}

resource "aws_route_table_association" "jenkins-master" {
  route_table_id = "${aws_route_table.jenkins-vpc-egress-ingress.id}"
  subnet_id      = "${aws_subnet.jenkins-master.id}"
}

resource "aws_route_table_association" "jenkins-nodes" {
  route_table_id = "${aws_route_table.jenkins-vpc-egress-ingress.id}"
  subnet_id      = "${aws_subnet.jenkins-nodes.id}"
}
