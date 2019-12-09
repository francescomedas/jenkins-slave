provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "jenkins-slave" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jenkins-node-base-image-centos-7-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["087131782018"]
}

resource "aws_autoscaling_group" "slave" {
  name                 = "jenkins-slave"
  max_size             = var.slaves_max_size
  min_size             = var.slaves_min_size
  desired_capacity     = var.slaves_desired_capacity
  health_check_type    = "EC2"
  force_delete         = true
  launch_configuration = aws_launch_configuration.slave.name
  vpc_zone_identifier  = [element(var.private_subnet_ids, 0)]
  depends_on           = [aws_launch_configuration.slave]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = "Name"
      value               = "jenkins-slave"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "Jenkins"
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = "DevOps Platform"
      propagate_at_launch = true
    },
  ]
}

resource "aws_launch_configuration" "slave" {
  image_id        = data.aws_ami.jenkins-slave.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.slave.id]
  depends_on      = [aws_security_group.slave]
  user_data       = data.template_file.slave_user_data.rendered
  root_block_device {
    volume_size = 20
  }
  ebs_block_device {
    volume_size = 100
    device_name = "/dev/xvdf"
  }

  lifecycle { create_before_destroy = true }
}

data "template_file" "slave_user_data" {
  template = "${file("${path.module}/startup-slave.sh.tpl")}"

  vars = {
    jenkins_url            = var.jenkins_url
    jenkins_username       = var.jenkins_username
    jenkins_password       = var.jenkins_password
    jenkins_credentials_id = var.jenkins_credentials_id
  }
}