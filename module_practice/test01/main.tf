
module "ec2_instance" {
  source         = "./modules/ec2_module"
  instance_name  = "my-ec2-instance"
  instance_type  = "t2.micro"
  ami_id         = "ami-0e2c8caa4b6378d8c" # Replace with a valid AMI ID
  ssh_cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
}
