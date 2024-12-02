In Terraform, **string type variables** are used to pass textual data to resources and modules. Using variables helps to make your configurations more flexible and reusable. Below, I'll explain how the string type variable works and how it's utilized in your `main.tf` file.

### 1. **Defining a String Type Variable**

```hcl
variable "instance_type" {
    description = "instance type t2.micro"
    type        = string
    default     = "t2.micro"
}
```

- **`variable "instance_type"`**: This block defines a variable named `instance_type`.
- **`description`**: A brief description of what the variable is used for (in this case, the type of EC2 instance).
- **`type = string`**: Specifies that the variable should be a string. This ensures that the value assigned to `instance_type` is always text.
- **`default = "t2.micro"`**: Sets a default value for the variable. If no value is passed during runtime, the default (`"t2.micro"`) will be used.

### 2. **Using the Variable in Your Main Configuration**

```hcl
resource "aws_instance" "myec2" {
    ami           = "ami-0fc5d935ebf8bc3bc"
    instance_type = var.instance_type
    tags = {
        Name = "My-instance"
    }
}
```

- **`instance_type = var.instance_type`**: This line assigns the value of the `instance_type` variable to the `instance_type` property of the `aws_instance` resource.
- Using `var.instance_type` allows you to dynamically set the instance type when running `terraform apply`. This makes the `aws_instance` resource more flexible, as you can specify the instance type when deploying your infrastructure without hard-coding it.

### 3. **Passing Variables During Runtime**

You can pass values to your Terraform variables in several ways:

- **Command-line input**: Use the `-var` flag to pass variables when running `terraform apply`:
  ```bash
  terraform apply -var="instance_type=t2.small"
  ```

- **Terraform `.tfvars` file**: Create a `variables.tfvars` file:
  ```hcl
  instance_type = "t2.large"
  ```
  Then, specify the file when running `terraform apply`:
  ```bash
  terraform apply -var-file="variables.tfvars"
  ```

- **Environment variables**: You can also use environment variables with the `TF_VAR_` prefix:
  ```bash
  export TF_VAR_instance_type="t2.medium"
  terraform apply
  ```

### **Benefits of Using Variables**
- **Modular Code**: Variables make your configuration files more adaptable and easier to reuse.
- **Separation of Configuration and Data**: You can manage values separately from the code, which helps with maintaining a clean structure and reducing hard-coded values.
- **Flexibility**: Changing a variable value allows you to quickly adjust the infrastructure without modifying the main code.

This setup enhances your ability to deploy infrastructure dynamically and make changes as needed without editing the main configuration.
