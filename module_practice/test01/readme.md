# Modules practice 
### Before proceed download pem file in local machine use that name into modules\ec2_module\main.tf 
```bash
key_name = "pem_filename"
```
## **1. Overview**
In Terraform, **modules** are containers for multiple resources that are used together. Instead of writing all Terraform code in a single file, you can create reusable modules.

### **Structure**
A Terraform module typically consists of:
- **Input variables** (to pass dynamic values)
- **Output values** (to retrieve values after resource creation)
- **Resources** (like EC2, Security Group)

---

## **2. Directory Structure**
Here is the directory structure for your Terraform project:

```bash
project/
│
├── main.tf                 # Root Terraform file to call the module
├── variables.tf            # Input variables for the root module
├── outputs.tf              # Output values for the root module
├── terraform.tfvars        # Values for input variables (optional)
└── modules/
    └── ec2_module/
        ├── main.tf         # Resources (EC2 and Security Group)
        ├── variables.tf    # Input variables for the module
        └── outputs.tf      # Output values for the module
```

---

## **3. Module Code (modules/ec2_module)**
Here is the code for your **`ec2_module`**.

### **modules/ec2_module/variables.tf** (Module Input Variables)
Define input variables for the module.

```hcl
variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
```

---

### **modules/ec2_module/main.tf** (Resources)
Define the EC2 instance and the Security Group.

```hcl
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
}
```

---

### **modules/ec2_module/outputs.tf** (Module Outputs)
Retrieve the EC2 instance details.

```hcl
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.ssh_sg.id
}
```

---

## **4. Root Module (main.tf)**
Call the **`ec2_module`** and pass variables.

### **main.tf**
```hcl
provider "aws" {
  region = "us-east-1" # Change to your desired region
}

module "ec2_instance" {
  source         = "./modules/ec2_module"
  instance_name  = "my-ec2-instance"
  instance_type  = "t2.micro"
  ami_id         = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID
  ssh_cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
}
```

---

## **5. Root Module Variables (variables.tf)**

Optional: Define default or customizable input variables for the root module.

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

---

## **6. Outputs (outputs.tf)**

Optional: Fetch outputs from the module.

```hcl
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2_instance.instance_public_ip
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.ec2_instance.security_group_id
}
```

---

## **7. terraform.tfvars (Optional)**
You can define values for your variables here.

```hcl
aws_region      = "us-east-1"
instance_name   = "my-ec2-instance"
instance_type   = "t2.micro"
ami_id          = "ami-0c55b159cbfafe1f0"
ssh_cidr_blocks = ["0.0.0.0/0"]
```

---

## **8. Steps to Deploy**

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan**:
   ```bash
   terraform plan
   ```

3. **Apply**:
   ```bash
   terraform apply
   ```

4. **Check Outputs**:
   After the apply completes, Terraform will print the outputs, including the **public IP** of the EC2 instance and the **Security Group ID**.

---

## **9. Summary**
1. The **module** (`ec2_module`) creates:
   - A **Security Group** to allow SSH access.
   - An **EC2 instance** with the defined AMI and instance type.

2. The **root module** calls this module, passing required variables like `instance_name`, `ami_id`, and `ssh_cidr_blocks`.

3. Outputs such as the **public IP** of the EC2 instance are retrieved for verification.

Let me know if you need further clarification or adjustments! 🚀