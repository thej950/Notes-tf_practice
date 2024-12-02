### Terraform Dynamic Blocks
- this terraform dynamic blocks are used to reduce the lines of terraform files

In Terraform, **dynamic blocks** provide a way to generate repeated nested blocks based on a collection of data. This allows you to create more flexible and modular Terraform configurations without needing to hard-code repetitive elements.

### Breakdown of Your Code:

1. **Dynamic Block Overview**:
   - The `dynamic` block in your code is used within the `aws_security_group` resource.
   - The purpose of the dynamic block is to create multiple `ingress` blocks based on a local variable called `local.ingress_rules`.
   - Each item in `local.ingress_rules` is iterated over to create an `ingress` block with specific attributes (`description`, `from_port`, `to_port`, etc.).

2. **Local Variable**:
   ```hcl
   locals {
     ingress_rules = [
       {
         port        = 443
         description = "Ingress rule for https"
       },
       {
         port        = 22
         description = "Ingress rule for ssh"
       }
     ]
   }
   ```
   - This `locals` block defines a collection of rules, each with `port` and `description`.
   - These rules will be used to dynamically create `ingress` blocks in the `aws_security_group` resource.

3. **Dynamic Block Structure**:
   ```hcl
   dynamic "ingress" {
     for_each = local.ingress_rules
     content {
       description = ingress.value.description
       from_port   = ingress.value.port
       to_port     = ingress.value.port
       protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
     }
   }
   ```
   - **`dynamic "ingress"`**: Indicates that we are dynamically generating `ingress` blocks.
   - **`for_each = local.ingress_rules`**: The `for_each` argument is used to iterate over the `local.ingress_rules` list. Each element in the list will generate an `ingress` block.
   - **`content { ... }`**: This block specifies the content structure of each dynamically generated `ingress` block. The `ingress.value` is used to access the current item in the iteration, allowing its `port` and `description` values to be used.
   - **`description = ingress.value.description`**: Uses the `description` property from the current `ingress_rule`.
   - **`from_port` and `to_port`**: Both set to `ingress.value.port`, defining which port is used for the ingress.
   - **`protocol = "tcp"`**: Specifies that the rule is for TCP traffic.
   - **`cidr_blocks = ["0.0.0.0/0"]`**: Opens the port to all IP addresses.

### Benefits of Using Dynamic Blocks:
- **Scalability**: You can add or remove rules in `local.ingress_rules` without changing the structure of the `aws_security_group` resource.
- **Reusability**: It avoids duplication, making the code easier to read and maintain.
- **Flexibility**: Adjusting the `local.ingress_rules` variable changes the generated `ingress` blocks without needing to rewrite code.

### Summary:
Dynamic blocks in Terraform help you define blocks in resources that are repeated based on a collection. In your example, the `dynamic "ingress"` block iterates over the `local.ingress_rules` variable, dynamically creating `ingress` blocks with the `port` and `description` values specified.
