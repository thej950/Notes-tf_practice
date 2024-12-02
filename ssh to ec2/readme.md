### **Steps to SSH into an EC2 Machine Using Terraform and SSH Keys**

---

### **Step 1: Generate SSH Keys**

Run the command below on your local machine to generate a pair of SSH keys:
```bash
ssh-keygen
```
- It will generate two files:
  - `id_rsa` (private key)
  - `id_rsa.pub` (public key)

Save these files securely. The public key will be added to your Terraform configuration, and the private key will be used for SSH access.

---

### **Step 2: Create Terraform Resources**

1. **AWS Security Group**: Configure a security group to allow inbound SSH access on port 22.

```hcl
resource "aws_security_group" "main-sg" {
  name = "main-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

2. **AWS Key Pair**: Import the public key into AWS as an EC2 key pair.

```hcl
resource "aws_key_pair" "myec2key" {
  key_name   = "aws-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key
}
```

3. **AWS EC2 Instance**: Launch an EC2 instance using the created key pair and security group.

```hcl
resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Replace with a valid AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.myec2key.key_name
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "My-instance"
  }
}
```

---

### **Step 3: Apply the Terraform Configuration**

Run the following commands to deploy the resources:

```bash
terraform init
terraform apply
```
- Confirm the creation of resources when prompted.
- Note the **public IP** of the EC2 instance in the output.

---

### **Step 4: Connect to the EC2 Instance**

Use the private key to connect to the instance:
1. Set permissions for the private key:
   ```bash
   chmod 400 ~/.ssh/id_rsa
   ```

2. Connect to the EC2 instance:
   ```bash
   ssh -i ~/.ssh/id_rsa ubuntu@<public_ip>
   ```
   Replace `<public_ip>` with the EC2 instance's public IP from the Terraform output.

---

### **Full Example Code**

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "main-sg" {
  name = "main-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "myec2key" {
  key_name   = "aws-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "myec2" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.myec2key.key_name
  vpc_security_group_ids = [aws_security_group.main-sg.id]

  tags = {
    Name = "My-instance"
  }
}
```

---

### **Verification**
- Ensure that the public IP of the EC2 instance is reachable.
- If you encounter issues connecting via SSH, check the security group settings to confirm port 22 is open.

