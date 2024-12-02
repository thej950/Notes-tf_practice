### **Terraform Modules Overview**

Terraform modules are reusable configurations that help organize code into logical, reusable components. They simplify managing complex infrastructure and allow for cleaner and more maintainable code. Each module contains its own `main.tf` file and can include other files like `variables.tf` and `outputs.tf`.

---

### **Folder Structure for Modules**

Here is an example folder structure with two modules:

```
project/
│
├── main.tf               # Parent/main Terraform file
├── module-1/             # First module
│   ├── main.tf           # Logic for Apache webserver 1
│   ├── variables.tf      # Variables for module 1
│   └── outputs.tf        # Outputs for module 1
│
├── module-2/             # Second module
│   ├── main.tf           # Logic for Apache webserver 2
│   ├── variables.tf      # Variables for module 2
│   └── outputs.tf        # Outputs for module 2
```

---

### **Parent `main.tf` File (Top-Level)**

The parent `main.tf` calls the modules. Each module is invoked with its own configuration.

```hcl
module "thej-webserver-1" {
  source = "./module-1" # Path to module 1
}

module "thej-webserver-2" {
  source = "./module-2" # Path to module 2
}
```

---

### **Module 1: Installing Apache Webserver**

**module-1/main.tf**
```hcl
resource "aws_instance" "web1" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  
  tags = {
    Name = "Apache-Webserver-1"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    echo "Welcome to Webserver 1" > /var/www/html/index.html
  EOF
}
```

---

### **Module 2: Installing Apache Webserver**

**module-2/main.tf**
```hcl
resource "aws_instance" "web2" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  
  tags = {
    Name = "Apache-Webserver-2"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    echo "Welcome to Webserver 2" > /var/www/html/index.html
  EOF
}
```

---

### **Run Terraform**

1. **Initialize the project**:
   ```bash
   terraform init
   ```

2. **Validate the configuration**:
   ```bash
   terraform validate
   ```

3. **Plan the infrastructure**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

---

### **Benefits of Using Modules**

1. **Reusability**: Code can be reused in different projects or parts of the infrastructure.
2. **Maintainability**: Easier to manage and update configurations as they are separated logically.
3. **Scalability**: Encourages modular design, making it simpler to scale infrastructure.
4. **Readability**: Clear structure reduces complexity for larger projects.

---
### Now create parent  terraform file

- this main.tf file containe to call modules 
- it is located on top folder location 

### To call modules 
        ```
        module "thej-webserver-1" {
            source = ".//module-1"
        }
        ```
