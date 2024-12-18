output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.ec2_instance.security_group_id
}
