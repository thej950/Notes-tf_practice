using **file provisioners** to copy a local file to a remote EC2 instance securely. This configuration includes the required resources such as the **AWS EC2 instance**, **security group**, and **key pair**.

---

```hcl
# **Provider Configuration**
provider "aws" {
  region = "us-east-1"
}

# **Key Pair Resource**
# Creates an AWS key pair for SSH access
resource "aws_key_pair" "mykey" {
  key_name   = "aws-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZE+e256IwqDbEM3twL11NshNd4XLFZzoLZ6hzYUUB0i6YGmnqAk+KizZUj+hECRNnX21+ZxdppMN+TKfhOEB0X3jyo8FQAqyL/b3Fq2lTkXOCmCz2iWyESR1z6kbJvTePqXm+q59/7yoQcTd/D4DP/Onk0Qtb52B+Z760LqpLSwyEq6WD3wQq0KDwaVfZ3Ppgm5LpdBg1M0kWBBndIum5Jrt8do6KsNokZ7tN+jOQWF1/9h+N27NQtoWWn+bTwhS4YfIkNxr44zxWNc9CUD5UsTff6Ve7tUwMnsBBErC/SPejldQTEP+cPSAEmhkJrAMohs1yGfK5bbn0/xbB/i30Y2R2/RLJbZEkuHqlIgsbDOW43XdAdic1Um2MG96iopdvZ5DGNZsB8Z+rr5JHSyxnf7ulK1S5mR9lqii0ZTl+3JuD36n1kbCgoz/fVJWpUpo+TT5Go6B5N8ApwuEuyN4/WJnSv9JOfxt2QtKbJGTSqJXkZbkHUYgJgz56mc5HYX8= DELL@Navathej"
}

# **Security Group Resource**
# Configures security group with inbound and outbound rules
resource "aws_security_group" "main-sg1" {
  name_prefix = "my-sg-"

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# **EC2 Instance Resource**
# Launches an EC2 instance and uses file provisioners
resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc" # Use an appropriate AMI for your region
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.main-sg1.id]

  tags = {
    Name = "My-instance"
  }

  # **File Provisioner**
  provisioner "file" {
    source      = "./test/test-file"            # Local file to be copied
    destination = "/home/ubuntu/test-file"     # Remote destination path
  }

  # **Connection Block**
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\DELL\\Desktop\\terraform-work\\provisioners\\file-provisioners\\sshkeys\\aws-key1")
    timeout     = "4m"  # Timeout duration for establishing the connection
  }
}
```

---

### **Explanation**
1. **Provider Configuration**:
   - Specifies the AWS region.

2. **Key Pair**:
   - Creates an SSH key pair using a public key for secure access to the instance.

3. **Security Group**:
   - Configures inbound rules to allow SSH (port 22) and outbound rules to allow all traffic.

4. **EC2 Instance**:
   - Uses the `ami` and `instance_type` to launch an instance.
   - Associates the instance with the key pair and security group.

5. **File Provisioner**:
   - Copies a file from the local machine (`source`) to the remote instance (`destination`).

6. **Connection**:
   - Uses SSH for a secure connection, requiring the private key and the instance's public IP.

---

### **Steps to Execute**
1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Plan the configuration:
   ```bash
   terraform plan
   ```
3. Apply the configuration:
   ```bash
   terraform apply
   ```

---

### **Output Example**
After a successful run, the specified file will be copied to the remote instance at `/home/ubuntu/test-file`. Use SSH to log in and verify:
```bash
ssh -i "C:\Users\DELL\Desktop\terraform-work\provisioners\file-provisioners\sshkeys\aws-key1" ubuntu@<public_ip>
ls /home/ubuntu/
```
---
### using **Local variable** 
---
Here's the updated Terraform configuration that uses **local variables** for reusable and better-maintained values. Local variables make the configuration more flexible and easier to update.

---

```hcl
# **Local Variables**
locals {
  aws_region       = "us-east-1"
  key_pair_name    = "aws-key1"
  public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZE+e256IwqDbEM3twL11NshNd4XLFZzoLZ6hzYUUB0i6YGmnqAk+KizZUj+hECRNnX21+ZxdppMN+TKfhOEB0X3jyo8FQAqyL/b3Fq2lTkXOCmCz2iWyESR1z6kbJvTePqXm+q59/7yoQcTd/D4DP/Onk0Qtb52B+Z760LqpLSwyEq6WD3wQq0KDwaVfZ3Ppgm5LpdBg1M0kWBBndIum5Jrt8do6KsNokZ7tN+jOQWF1/9h+N27NQtoWWn+bTwhS4YfIkNxr44zxWNc9CUD5UsTff6Ve7tUwMnsBBErC/SPejldQTEP+cPSAEmhkJrAMohs1yGfK5bbn0/xbB/i30Y2R2/RLJbZEkuHqlIgsbDOW43XdAdic1Um2MG96iopdvZ5DGNZsB8Z+rr5JHSyxnf7ulK1S5mR9lqii0ZTl+3JuD36n1kbCgoz/fVJWpUpo+TT5Go6B5N8ApwuEuyN4/WJnSv9JOfxt2QtKbJGTSqJXkZbkHUYgJgz56mc5HYX8= DELL@Navathej"
  ami_id           = "ami-0fc5d935ebf8bc3bc"
  instance_type    = "t2.micro"
  security_group_name_prefix = "my-sg-"
  ssh_private_key_path = "C:\\Users\\DELL\\Desktop\\terraform-work\\provisioners\\file-provisioners\\sshkeys\\aws-key1"
  local_file_path          = "./test/test-file"
  remote_file_destination  = "/home/ubuntu/test-file"
}

# **Provider Configuration**
provider "aws" {
  region = local.aws_region
}

# **Key Pair Resource**
# Creates an AWS key pair for SSH access
resource "aws_key_pair" "mykey" {
  key_name   = local.key_pair_name
  public_key = local.public_key
}

# **Security Group Resource**
# Configures security group with inbound and outbound rules
resource "aws_security_group" "main_sg" {
  name_prefix = local.security_group_name_prefix

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# **EC2 Instance Resource**
# Launches an EC2 instance and uses file provisioners
resource "aws_instance" "myec2" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.main_sg.id]

  tags = {
    Name = "My-instance"
  }

  # **File Provisioner**
  provisioner "file" {
    source      = local.local_file_path
    destination = local.remote_file_destination
  }

  # **Connection Block**
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(local.ssh_private_key_path)
    timeout     = "4m"  # Timeout duration for establishing the connection
  }
}
```

---

### **Advantages of Using Local Variables**
1. **Reusability**: Avoids repetitive hardcoding.
2. **Maintainability**: Easy to update values globally in one place.
3. **Readability**: Improves the readability and organization of the Terraform configuration.

---

### **Steps to Execute**
1. **Initialize Terraform**:
   ```bash
   terraform init
   ```
2. **Plan the Configuration**:
   ```bash
   terraform plan
   ```
3. **Apply the Configuration**:
   ```bash
   terraform apply
   ```
