output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.ssh_sg.id
}
