In Terraform, **boolean type variables** are used to represent `true` or `false` values. This is useful for enabling or disabling features or conditions in your infrastructure code. Here's a breakdown of how to use boolean type variables in your `main.tf` file.

### 1. **Defining a Boolean Type Variable**

```hcl
variable "enable_public_ip" {
    description = "Enable public IP address"
    type        = bool
    default     = true
}
```

- **`variable "enable_public_ip"`**: This block defines a variable named `enable_public_ip`.
- **`description`**: A brief explanation of the variable's purpose (whether a public IP should be associated with the instance).
- **`type = bool`**: Ensures the variable accepts only `true` or `false` as valid values.
- **`default = true`**: Sets a default value of `true`, meaning by default the public IP will be enabled for the EC2 instance.

### 2. **Using the Boolean Variable in the Resource**

```hcl
resource "aws_instance" "myec2" {
    ami                         = "ami-0fc5d935ebf8bc3bc"
    instance_type               = var.instance_type
    count                       = 2
    associate_public_ip_address = var.enable_public_ip
    tags = {
        Name = "My-instance-1"
    }
}
```

- **`associate_public_ip_address = var.enable_public_ip`**: This line uses the `enable_public_ip` variable to determine if the EC2 instance should have a public IP address. If `var.enable_public_ip` is `true`, the instance will have a public IP. If `false`, it will not.
- **`count = 2`**: This creates two instances. This is an example of using the variable to control resource creation, but it can be modified to include or exclude resources based on a condition.

### 3. **Passing Boolean Variables**

You can pass values to boolean variables in different ways:

- **Command-line input**:
  ```bash
  terraform apply -var="enable_public_ip=false"
  ```

- **Terraform `.tfvars` file**:
  ```hcl
  enable_public_ip = false
  ```
  Then use:
  ```bash
  terraform apply -var-file="variables.tfvars"
  ```

- **Environment variables**:
  ```bash
  export TF_VAR_enable_public_ip=false
  terraform apply
  ```

### **Benefits of Using Boolean Variables**
- **Conditional Logic**: You can easily toggle settings, such as whether to assign public IPs, create resources, or enable specific configurations.
- **Enhanced Readability**: Code readability is improved as the configuration is more expressive and easier to understand (e.g., `enable_public_ip = true`).
- **Flexibility and Reusability**: By using boolean variables, you can customize your infrastructure deployment to include or exclude certain features without modifying the code itself.

This approach helps you control aspects of your infrastructure dynamically, making it adaptable for different environments or use cases.
