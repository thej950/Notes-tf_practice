In Terraform, **list type variables** are used to store an ordered collection of items, which can be strings, numbers, or other data types. They are particularly useful when you need to create multiple resources based on a set of data. Here's an example of using list type variables to create multiple IAM users in AWS.

### 1. **Defining a List Type Variable**

```hcl
variable "user_names" {
    description = "IAM-Users"
    type        = list(string)
    default     = ["ramu", "raki", "raghu", "ramesh"]
}
```

- **`variable "user_names"`**: This block defines a variable named `user_names`.
- **`type = list(string)`**: Specifies that `user_names` should be a list of strings.
- **`default = ["ramu", "raki", "raghu", "ramesh"]`**: Sets the default value as a list of IAM user names.

### 2. **Using the List Type Variable in the Resource**

```hcl
resource "aws_iam_user" "iam-users" {
    count = length(var.user_names)
    name  = var.user_names[count.index]
}
```

- **`count = length(var.user_names)`**: This creates as many `aws_iam_user` resources as there are elements in the `user_names` list. The `count.index` is used to reference the current index of the iteration.
- **`name = var.user_names[count.index]`**: The `name` attribute is set to the current element in the `user_names` list based on the index.

### 3. **Explanation of Resource Creation**

- **Creating Multiple IAM Users**: The `count` meta-argument allows Terraform to create multiple instances of a resource. The value of `count` is determined by the length of the `user_names` list, which in this example is 4 (`["ramu", "raki", "raghu", "ramesh"]`).
- **Iteration Using `count.index`**: The `count.index` variable provides the current index of the resource being created, allowing you to access each name in the `user_names` list sequentially.

### **Outcome**
The given configuration will create 4 IAM users named **"ramu"**, **"raki"**, **"raghu"**, and **"ramesh"** in AWS.

### 4. **Passing List Variables**

You can pass list variables in several ways:

- **Command-line input**:
  ```bash
  terraform apply -var='user_names=["john", "jane", "doe"]'
  ```

- **Terraform `.tfvars` file**:
  ```hcl
  user_names = ["alice", "bob", "carol"]
  ```

  Then use:
  ```bash
  terraform apply -var-file="variables.tfvars"
  ```

- **Environment variables**:
  ```bash
  export TF_VAR_user_names='["user1", "user2", "user3"]'
  terraform apply
  ```

### **Benefits of Using List Variables**
- **Scalability**: Easily create multiple resources without duplicating code.
- **Flexibility**: Modify the list to add or remove users without changing the resource block.
- **Readability**: The use of lists makes the configuration more readable and concise.

This approach is efficient for managing multiple resources that share similar configurations, such as creating IAM users, EC2 instances, security groups, etc., in a scalable way.
