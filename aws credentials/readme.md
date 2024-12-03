# **Configuring AWS Credentials in Terraform**

There are multiple ways to configure AWS credentials for Terraform to interact with AWS resources. The three most popular methods are:

---

## **1. Hard-Coded AWS Credentials**  
- **Not recommended** for production environments due to security risks.
- AWS credentials are directly embedded in the Terraform configuration file.

### **Example: Hard-Coded AWS Credentials**
```hcl
provider "aws" {
  access_key = "AKIARVZBY3GJSE3OYOOB"
  secret_key = "sXgKUSwfnuAy3s8sZTcxNDrt1BfT7ArbUdzSNH24"
  region     = "us-east-1"
}
```

### **Disadvantages:**
- Credentials can be exposed if files are shared.
- High risk of accidental exposure in version control (e.g., GitHub).

---

## **2. Shared Credentials File**
- AWS credentials are stored securely in a file on the system.
- Terraform refers to this file for authentication.

### **Step 1: Generate the Credentials File**
Use the AWS CLI to configure credentials:
```bash
$ aws configure
```
This creates the credentials file at:  
**Windows**: `C:\Users\<Username>\.aws\credentials`  
**Linux/MacOS**: `~/.aws/credentials`

Alternatively, manually create the file:
```plaintext
[default]
aws_access_key_id = AKIARVZBY3GJSE3OYOOB
aws_secret_access_key = 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
```

### **Step 2: Reference the Shared Credentials File**
```hcl
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "C:\\Users\\DELL\\.aws\\credentials" # Use forward slashes in Windows paths
}
```

### **Advantages:**
- Keeps sensitive data outside the Terraform configuration file.
- Shared across tools like AWS CLI and SDKs.

---

## **3. Environment Variables**
- Store AWS credentials in system environment variables.
- Useful for temporary credentials or automation pipelines.

### **Step 1: Export AWS Credentials**
Run the following commands:
```bash
$ export AWS_ACCESS_KEY_ID="AKIARVZBY3GJSE3OYOOB"
$ export AWS_SECRET_ACCESS_KEY="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"
```

### **Step 2: Configure the Provider**
Terraform automatically detects environment variables if set correctly:
```hcl
provider "aws" {
  region = "us-east-1"
}
```

### **Advantages:**
- Avoids storing sensitive data in files.
- Works well in CI/CD pipelines.

---

## **Comparison of AWS Credential Configuration Methods**

| **Method**                | **Pros**                                         | **Cons**                                   |
|---------------------------|-------------------------------------------------|-------------------------------------------|
| Hard-Coded AWS Credentials | Simple and straightforward                     | Security risk, not scalable.              |
| Shared Credentials File    | Secure and reusable across multiple tools      | Requires setting up the credentials file. |
| Environment Variables      | Great for automation and temporary credentials | Variables need to be exported explicitly. |

---
# Profile
## Here we can also use name instead of defaults 
```bash
vim ~/.aws/credentials
```

```bash
[thej]
aws_access_key_id = AKIA2LW3XXCQXISFFGWM
aws_secret_access_key = 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
```
- use above profile in provoder.tf file or provider section 
```hcl
provider "aws" {
  region = "us-east-1"
  profile = "thej"
```
## **Best Practices**
1. **Avoid Hard-Coding Credentials:** Always keep credentials secure and outside the main configuration file.
2. **Use Shared Credentials File or Environment Variables:** These methods are safer and more manageable.
3. **Leverage IAM Roles for Automation:** For long-term scalability, use IAM roles instead of keys in automation systems like EC2 or ECS.
4. **Git Exclusions:** Add `.terraform` and any sensitive files to `.gitignore` to prevent accidental sharing.

```plaintext
# .gitignore
.terraform/
*.tfstate
.aws/credentials
```

By following these practices, you can securely manage AWS credentials in Terraform.
```
