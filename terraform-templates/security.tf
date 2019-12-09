resource "aws_security_group" "slave" {
  name        = "jenkins-slave"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "jenkins-slave"
    Application = "Jenkins"
    Owner       = "DevOps Platform"
  }
}