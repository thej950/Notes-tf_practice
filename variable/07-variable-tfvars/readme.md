Using multiple `.tfvars` files allows you to manage and set up different environments with a single `main.tf` configuration. This approach helps separate environment-specific configurations while using the same infrastructure code. Here's how you can work with multiple `.tfvars` files and apply them to different environments.

### 1. **Creating Multiple `.tfvars` Files**

**`staging.tfvars`**:
```hcl
instance_type = "t2.micro"
environment_name = "staging"
```

**`production.tfvars`**:
```hcl
instance_type = "t2.large"
environment_name = "production"
```

### 2. **Creating `variables.tf` File**

This file defines the variables that will be used in `main.tf`:

```hcl
variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
}

variable "environment_name" {
    description = "Name of the environment"
    type        = string
}
```

### 3. **Using Variables in `main.tf`**

Reference these variables in your main configuration:

```hcl
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my-ec2" {
    ami           = "ami-0fc5d935ebf8bc3bc"
    instance_type = var.instance_type
    tags = {
        Name = var.environment_name
    }
}
```

### 4. **Applying Different `.tfvars` Files**

You can specify which `.tfvars` file to use when running `terraform plan` or `terraform apply`. This allows you to set up different environments with the same `main.tf` configuration.

**For staging environment**:
```bash
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
```

**For production environment**:
```bash
terraform plan -var-file="production.tfvars"
terraform apply -var-file="production.tfvars"
```

### 5. **Passing Default Values via Command Line**

If you don’t want to create `.tfvars` files, you can pass variable values directly on the command line using the `-var` flag.

**Apply using command line**:
```bash
terraform apply -var="instance_type=t2.micro" -var="environment=test"
```

**Destroy using command line**:
```bash
terraform destroy -var="instance_type=t2.micro" -var="environment=test"
```

### **Best Practices**

- **Organize `.tfvars` Files**: Use descriptive names for `.tfvars` files, such as `staging.tfvars`, `production.tfvars`, etc., to clearly indicate the environment.
- **Avoid Sensitive Data in `.tfvars`**: Do not include sensitive information like access keys or passwords in `.tfvars` files. Use environment variables or a secrets manager instead.
- **Environment-Specific Logic**: If you need to include environment-specific logic in `main.tf`, you can use conditional expressions or `count` and `for_each` meta-arguments to handle different configurations.

This approach helps you keep your infrastructure code consistent while maintaining different configurations for various environments.

# Multiple tfvars file usage 
* terraform tfvars files are used for to setup multiple environments like example using single main.tf file we can setup multiple environments 
* like we can create  multiple tfvars files based on our requirements 
* file name can be anything but extensions should be .tfvars 
* In this tfvars file containe Actual value of variable.tf 

# Creating Multiple tfvars file use in one single Loaction with one main terraform file 
> creating staging.tfvars

    instance_type="t2.micro"									
		
    enviroment_name="staging"

> creating production.tfvars 

  	instance_type="t2.micro"
		
	environment_name="production" 

> creating variable.tf file 

		
	variable "instance_type" {
	}
		
	variable "environment_name" {
	}

# now To pass variable or include into resource section on main terraform file 


    resource "aws_instance" "my-ec2" {
        ami           = "ami-0fc5d935ebf8bc3bc"
        instance_type = var.instance_type
        tags = {
            Name = var.environment_name
        }
    }


# Now supply different tfvars within the same Location with Single main terraform file using below command 

> Below commands for staging environment 

    $ terraform plan -var-file="staging.tfvars"
    $ terraform apply -var-file="staging.tfvars

> Below commands for Production environment 

    $ terraform plan -var-file="production.tfvars
    $ terraform apply -var-file="production.tfvars 

# To pass default values using command line without creating tfvars files 
- To Apply using command Line 
    
        $ terraform apply -var="instance_type=t2.micro" -var="environment=test"

- To destroy using command Line 
   
        $ terraform destroy -var="instance_type=t2.micro" -var="environment=test"
