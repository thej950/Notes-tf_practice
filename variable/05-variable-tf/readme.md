When using Terraform, it's a best practice to separate variable definitions from the main configuration by creating a `variables.tf` file. This helps keep your infrastructure code modular, organized, and more manageable. Here’s how to set it up:

### 1. **Creating a `variables.tf` File**

- The `variables.tf` file is where you define the variables that will be used in your main configuration. You can create this file using any text editor, such as `vim`, `nano`, or `code`.

```bash
$ vim variables.tf
```

- Inside `variables.tf`, define the variable using the `variable` block. Here's an example of how to define a variable for `instance_type`:

```hcl
variable "instance_type" {
    description = "Instance type for the EC2 instance, e.g., t2.micro"
    type        = string
    default     = "t2.micro"
}
```

- **Explanation**:
  - **`description`**: Provides a description for the variable.
  - **`type`**: Specifies the type of the variable, in this case, a `string`.
  - **`default`**: Sets a default value for the variable, which is optional.

### 2. **Referencing Variables in `main.tf`**

- Now create or edit the `main.tf` file and reference the variable defined in `variables.tf`.

```hcl
provider "aws" {
    region     = "eu-central-1"
    access_key = "<INSERT_YOUR_ACCESS_KEY>"
    secret_key = "<INSERT_YOUR_SECRET_KEY>"
}

resource "aws_instance" "ec2_example" {
    ami           = "ami-0767046d1677be5a0"
    instance_type = var.instance_type  # Reference to the variable defined in variables.tf

    tags = {
        Name = "Terraform EC2"
    }
}
```

- **Explanation**:
  - **`var.instance_type`**: This is how you reference the `instance_type` variable that was defined in `variables.tf`.
  - **`tags`**: The tags section is used to assign metadata to the AWS instance.

### 3. **Benefits of Using `variables.tf`**

- **Separation of Concerns**: Keeps variable definitions separate from resource configurations, making the code more organized and readable.
- **Reusability**: Allows you to easily reuse variables across different modules and configurations.
- **Simplified Management**: You can maintain a single `variables.tf` file to manage all variables used in the project, making it easier to manage and update them.

### 4. **Passing Variables to Terraform**

Variables in `variables.tf` can be overridden in multiple ways:

- **Using Command-Line Input**:
  ```bash
  terraform apply -var="instance_type=t3.medium"
  ```

- **Using a `.tfvars` File**:
  Create a `terraform.tfvars` file or a custom `.tfvars` file:
  ```hcl
  instance_type = "t3.medium"
  ```

  Then apply using:
  ```bash
  terraform apply -var-file="terraform.tfvars"
  ```

- **Environment Variables**:
  ```bash
  export TF_VAR_instance_type="t3.medium"
  terraform apply
  ```

### 5. **Best Practices**

- **Use Descriptive Names**: Name your variables meaningfully so their purpose is clear.
- **Document Variables**: Always include `description` in the `variable` block for better understanding.
- **Separate Configurations**: Use `variables.tf` for variable definitions and keep `main.tf` for the main configuration logic.

By structuring your Terraform code with `variables.tf` and `main.tf` files, you improve code maintainability, make it easier to manage configurations, and create a more scalable infrastructure codebase.
