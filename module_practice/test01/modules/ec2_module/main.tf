# Security Group for SSH Access
resource "aws_security_group" "ssh_sg" {
  name        = "${var.instance_name}-ssh-sg"
  description = "Security Group to allow SSH access"

  ingress {
    description = "SSH from allowed CIDR blocks"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.ssh_sg.id]
  tags = {
    Name = var.instance_name
  }
  key_name = "my-awskey" # make sure this pem file already available in local machine (or) download before with same name 
}
