variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "sg_for_jenkins" {}


output "jenkins_ec2_instance_ip" {
  value = aws_instance.jenkins_ec2_instance_ip.id
}

resource "aws_instance" "jenkins_ec2_instance_ip" {
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids      = var.sg_for_jenkins
  tags = {
    Name = var.tag_name
  }
}
