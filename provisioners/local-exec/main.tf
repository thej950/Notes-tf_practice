provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARVZBY3GJYYYBTQ74"
  secret_key = "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"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  tags = {
    Name = "My-instance"
  }
  provisioner "local-exec" {
    command = "echo 'HelloWorld' > output.txt"
  }
}