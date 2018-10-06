
data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*-x86_64-gp2"]
  }

  owners = ["137112412989"] # Amazon
}

/*resource "aws_key_pair" "jenkins-master" {
  vars {
    home = "${env.HOME}"
    id_rsa_pub = "${home}/.ssh/id_rsa.pub"
  }
  public_key = "${file("${id_rsa_pub}")}"
}*/

data aws_ebs_snapshot "jenkins-afalko-net" {
  filter {
    name = "description"
    values = ["jenkins.afalko.net"]
  }
}

resource "aws_instance" "jenkins-master" {
  ami = "${data.aws_ami.amzn2.id}"
  instance_type = "t2.small"
  availability_zone = "${var.az}"
  vpc_security_group_ids = ["${aws_security_group.jenkins-master.id}"]
  subnet_id = "${aws_subnet.jenkins-master.id}"
  #spot_price = ".026"
  user_data = "${file("master-userdata.sh")}"

  # Generally, keep this commented; best to have machines automated to the
  # where login is never needed, but it is too convenient to push this config in
  # TODO: Create new key pair
  key_name = "debug"
  # TODO: Use S3 for these
  provisioner "file" {
    source      = ".jenkins.env"
    destination = "/var/tmp/.jenkins.env"
  }
}

resource "aws_eip" "jenkins-master" {
  vpc = true
  instance = "${aws_instance.jenkins-master.id}"
}

data aws_route53_zone "afalko-net" {
  name = "afalko.net"
}

resource "aws_route53_record" "jenkins-afalko-net" {
  name = "jenkins.afalko.net"
  type = "A"
  zone_id = "${data.aws_route53_zone.afalko-net.id}"
  records = ["${aws_eip.jenkins-master.public_ip}"]
  ttl = 60
}