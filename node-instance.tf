resource "aws_key_pair" "jenkins-nodes" {
  public_key = "${file("node-key.pub")}"
  key_name   = "jenkins-nodes"
}

resource "aws_launch_template" "jenkins-nodes" {
  name_prefix = "jenkins-node"

  #image_id = "${data.aws_ami.amzn2.id}"
  image_id      = "ami-9887c6e7"
  instance_type = "t3.nano"

  # TODO: Bug:
  #vpc_security_group_ids = ["${aws_security_group.jenkins-nodes.id}"]
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = ["${aws_security_group.jenkins-nodes.id}"]
  }

  /*instance_market_options {
      market_type = "spot"
      spot_options {
        max_price = ".0052"
      }
    }*/
  key_name = "${aws_key_pair.jenkins-nodes.key_name}"

  user_data = "${base64encode(file("node-userdata.sh"))}"
}

resource "aws_autoscaling_group" "jenkins-nodes" {
  availability_zones = [
    "${var.az}",
  ]

  #subnet = "${aws_subnet.jenkins-nodes.id}" TODO: Bug with terraform? I can add this manually in EC2 UI
  desired_capacity    = 4
  max_size            = 4
  min_size            = 4
  vpc_zone_identifier = ["${aws_subnet.jenkins-nodes.id}"]

  launch_template = {
    id      = "${aws_launch_template.jenkins-nodes.id}"
    version = "${aws_launch_template.jenkins-nodes.latest_version}"
  }
}
