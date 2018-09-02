
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
  provisioner "file" {
    source      = ".jenkins.env"
    destination = "/root/.jenkins.env"
  }
}

resource "aws_eip" "jenkins-master" {
  vpc = true
  instance = "${aws_instance.jenkins-master.id}"
}
/*
resource "aws_launch_configuration" "jenkins-nodes" {
  name_prefix = "jenkins-master"
  image_id = "${data.aws_ami.amzn2.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.jenkins-nodes.id}"]
  // Spot instances
  spot_price = ".013"
  #user_data = "yum install -y docker"
}

resource "aws_autoscaling_group" "jenkins-nodes" {
  availability_zones = [
    "${var.az}"]
  desired_capacity = 4
  max_size = 4
  min_size = 4
  launch_configuration = "${aws_launch_configuration.jenkins-nodes.id}"
}*/

/*
resource "aws_elb" "jenkins" {
  name = "jenkins"
  availability_zones = [
    "${var.az}"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = ""
    interval = 30
  }
}*/