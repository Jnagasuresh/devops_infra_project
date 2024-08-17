
## Terraform

Terraform is an open-source infrastructure as code (IaC) tool created by HashiCorp. It allows you to define, provision, and manage cloud infrastructure and services through declarative configuration files. Terraform enables you to describe your infrastructure using a high-level configuration language called HashiCorp Configuration Language (HCL) or JSON, and then use these descriptions to create, modify, or destroy the infrastructure across multiple cloud providers.

### Key Concepts

1. **Infrastructure as Code (IaC)**:
   - Terraform treats your infrastructure as code, allowing you to version, review, and share your configurations just like any other software code. This makes infrastructure management more consistent, repeatable, and automated.

2. **Declarative Language**:
   - Terraform uses a declarative language (HCL) to define your desired state of infrastructure. You specify **what** you want, and Terraform figures out **how** to achieve that state.

3. **Providers**:
   - Terraform supports a wide range of cloud providers, such as AWS, Azure, Google Cloud, and many others, through plugins called providers. Providers are responsible for understanding API interactions with cloud services.

4. **Resources**:
   - Resources are the most basic components in Terraform. They represent infrastructure objects like virtual machines, networks, databases, etc. For example, an `aws_instance` resource might represent an EC2 instance in AWS.

5. **State**:
   - Terraform maintains a state file that tracks the current state of your infrastructure. This state file allows Terraform to know what resources are already managed and how to create or update them.

6. **Modules**:
   - Modules are reusable groups of resources. They allow you to create complex infrastructure components that can be used across multiple environments or projects, promoting code reuse and organization.

7. **Plan and Apply**:
   - `terraform plan`: This command shows you what changes Terraform will make to your infrastructure before actually applying those changes.
   - `terraform apply`: This command applies the changes to your infrastructure based on your configuration files and the current state.

8. **Provisioners**:
   - Provisioners in Terraform are used to execute scripts or commands on a local or remote machine as part of resource creation or destruction. While useful, provisioners should be used sparingly as they can break the declarative nature of Terraform.

### Workflow

1. **Write Configuration**: 
   - You define your infrastructure using HCL or JSON in `.tf` files.
   
2. **Initialize**:
   - `terraform init`: Initializes your Terraform environment, downloads necessary provider plugins, and sets up the backend for state storage.

3. **Plan**:
   - `terraform plan`: Terraform generates an execution plan that shows what actions it will take to achieve the desired state defined in your configuration files.

4. **Apply**:
   - `terraform apply`: Applies the execution plan to create, update, or destroy resources in your infrastructure.

5. **State Management**:
   - Terraform keeps track of your infrastructure in a state file, allowing you to manage complex environments over time.

6. **Destroy**:
   - `terraform destroy`: Removes all resources defined in your configuration files.

### Example

Here’s a basic example of a Terraform configuration to create an AWS EC2 instance:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "MyInstance"
  }
}
```

### Use Cases

- **Multi-Cloud Management**: Terraform allows you to manage infrastructure across multiple cloud providers from a single configuration.
- **Automation**: Automate the provisioning and scaling of your infrastructure.
- **Infrastructure Versioning**: Track and version your infrastructure changes, ensuring that you can roll back if needed.
- **Disaster Recovery**: Recreate your entire infrastructure in a different region or cloud provider using the same configuration.

### Advantages

- **Cloud-Agnostic**: Terraform supports a wide range of cloud providers, making it easier to manage multi-cloud environments.
- **Modularity**: With modules, you can create reusable and maintainable infrastructure components.
- **Collaborative**: Terraform’s configuration files can be shared and collaborated on, similar to other code in a version control system.

### Disadvantages

- **State Management Complexity**: Managing the state file, especially in team environments, can be complex.
- **Learning Curve**: For those new to infrastructure as code, Terraform's concepts and syntax can take some time to learn.
- **Limited Procedural Logic**: Terraform's declarative approach can sometimes make certain tasks, like looping or conditional logic, less intuitive compared to scripting languages.

Terraform is a powerful tool that provides a consistent and reliable way to manage your infrastructure, helping teams automate and scale their infrastructure with ease.
###Workflow

* Terraform init: is a command in Terraform that initializes a working directory containing Terraform configuration files.
* Terraform validate: The terraform validate command is used to validate the syntax and configuration of your Terraform files. It checks whether your Terraform configuration is syntactically valid and internally consistent, but it does not interact with any remote services (e.g., cloud providers)
  - Terrafrom will validate only **keys** (left side), Terraform won't validate Values (right side)



* Terraform apply
* terraform destroy


* Terrafrom commands must run inside the folder onley.

* Terraform provider [Terraform providers documentation](https://registry.terraform.io/browse/providers)

#### Azure provider

 * on terraform init, provider repositories downloaded in **.terraform**
 * providers are downloaded from **Terraform registry**

```
    provider "azurerm" {
    features {}

    # Optional, can specify specific configuration if needed
    subscription_id = var.azure_subscription_id
    client_id       = var.azure_client_id
    client_secret   = var.azure_client_secret
    tenant_id       = var.azure_tenant_id
    }
```
#### GCP
```
provider "google" {
  credentials = file("<path-to-your-service-account-key>.json")
  project     = var.gcp_project
  region      = var.gcp_region
}
```
#### AWS

```
    provider "aws" {
    region     = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    }

```
# '#' for commeninting


#### Terrafrom Plan

* Creates an execution plan
* It is just like a dryrun
* Whats the desired state you will achive, once you create the, manifest.

* Terraform plan: The terraform plan command is used to create an execution plan for your Terraform configuration. This command analyzes your configuration and shows you what actions Terraform will take to achieve the desired state described in your configuration files. It does not make any changes to the real infrastructure but provides a preview of what will happen when you run terraform apply.

#### Terraform apply

* Used to apply the changes required to reach the desired state of the configuration we wrote in the .tf files
* Apply option will crate the resources.

#### Destroy
* This is used to destroy the terraform managed infrastructure.


### Key words
* Desired state
* Idempotent
* Terraform Registry
* Hasicorp
* Terraform init
* Terrafrom Validate
* Terraform plan
* Terraform apply
* Terraform destroy
* Terraform Modules
* Terraform Statefile
* Terraform 

### Terraform Language
 * we write teh code in the language which terraform understands
 * Language is Hasicorp
 * Workflow
 * Blocks
 * arguments
 * identifiers
 * Comments


 ### Terraform fundamental blocks

 #### Settings block
 The special terraform configuration block type is used to configure some behaviors of Terraform itself, such as requiring a minimum Terraform version to apply your configuration.

 ##### Syntax
 ```
 terraform {
  # ...
}
```
[Setting Block documentation](https://developer.hashicorp.com/terraform/language/settings)
```
 terraform {
  required_version = "value"

  required_providers {
    aws = {
        version= "value"
        source = "hashicorp/aws"
    }
  }

  # remote backend solution
   
   backend "s3" {
    bucket = "value"
   }
  # Experiments
  experiments = []

  # metadata
  provider_meta "" {

  }
}
  

```

#### Version constraint

version = ">= 1.2.0, < 2.0.0"

~>: Allows only the rightmost version component to increment. This format is referred to as the pessimistic constraint operator. For example, to allow new patch releases within a specific minor release, use the full version number:

  - Specifying a Required Terraform Version
  -  Configuring a Terraform Backend

  ## State File
   *  **terraform.tfstate** file
   * Terraform brain is stored in Statefile.
   * Terrafrom state file must store in external backend source.

```
   terraform apply --auto-approve
```

## Meta-Argument

to change the behaviour of existing resources
* depends_on
* count
* for_each
* provider
* lifecycle
* provisioners and connections

### depends_on
 Use the depends_on meta-argument to handle hidden resource or module dependencies that Terraform cannot automatically infer. You only need to explicitly specify a dependency when a resource or module relies on another resource's behavior but does not access any of that resource's data in its arguments

 * It is not recommended to use multiple depends_on
 ### Terraform `depends_on` Meta-Argument

The `depends_on` meta-argument in Terraform explicitly defines dependencies between resources. While Terraform's dependency graph usually infers these relationships based on resource references, there are cases where you need to enforce a specific order of operations that Terraform might not otherwise detect. This is where `depends_on` comes in.

#### When to Use `depends_on`

- **Explicit dependencies**: When Terraform cannot infer dependencies correctly, such as when there are indirect relationships between resources.
- **Complex configurations**: When you want to ensure that a resource is created or modified only after another resource has been fully applied.
- **Avoiding race conditions**: In scenarios where resources might be provisioned in parallel but require a specific order.

#### Key Points

- **Implicit Dependencies**: Usually, Terraform can infer dependencies from references. For example, if one resource uses the ID of another, Terraform knows to create the referenced resource first.
- **Explicit Dependencies**: Use `depends_on` when Terraform might not infer the correct order, such as when using modules or when dependencies aren't directly referenced.

 
 ```
  depends_on = [
     aws_internet_gateway.tf-vpc-igw
  ]
 ```

 ### Count
 * **A given resouce or module block cannot use both count and for_each.**
 * Accepts only whole number
 * count.index # 0,1,2...

 ### for_each

 * A given resouce or module block cannot use both count and for_each.
 * each.key
 * each.value
 * can be used both set of strings or map (dictionary)

 In Terraform, `count` and `for_each` are two mechanisms for creating multiple resources. They both help manage multiple instances of a resource, but they have different use cases and behaviors. Here’s a detailed comparison along with examples and use cases for each.

### `count`

**Purpose**: The `count` parameter is used to specify how many instances of a resource should be created. It is a simple way to create multiple identical resources.

**Use Cases**:
- When you need to create a specific number of identical resources.
- When the instances don't need unique configurations based on input.

**Example**:
Creating multiple identical virtual machines:

```hcl
resource "aws_instance" "example" {
  count         = 3
  ami           = "ami-123456"
  instance_type = "t2.micro"
  
  tags = {
    Name = "example-instance-${count.index}"
  }
}
```

**Explanation**:
- This will create 3 EC2 instances with identical configurations.
- `${count.index}` is used to uniquely tag each instance.

### `for_each`

**Purpose**: The `for_each` parameter is used to iterate over a set of items, allowing you to create resources based on the elements of a map or set.

**Use Cases**:
- When you need to create resources with unique configurations.
- When you need to manage resources using a map or set where each element can have different properties.

**Example**:
Creating multiple virtual machines with different configurations:

```hcl
variable "instances" {
  type = map(object({
    ami           = string
    instance_type = string
  }))
  default = {
    "instance1" = { ami = "ami-123456", instance_type = "t2.micro" }
    "instance2" = { ami = "ami-789012", instance_type = "t2.small" }
    "instance3" = { ami = "ami-345678", instance_type = "t2.medium" }
  }
}

resource "aws_instance" "example" {
  for_each      = var.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }
}
```

```terraform
resource "aws_s3_bucket" "example" {
  for_each = {
    "dev"  = "boutique-micro-services"
    "qa"   = "boutique-micro-services-tst"
    "prod" = "boutique-micro-services-prd"
  }

  # dev-boutique-micro-services
  # qa-boutique-micro-services-tst
  # prod-boutique-micro-services-prd
  
  bucket = "${each.key}-${each.value}"

  tags = {
    Environment = each.key
  }
}
```

**Explanation**:
- This will create 3 EC2 instances, each with different configurations as defined in the `instances` variable.
- `each.key` and `each.value` are used to access the keys and values of the map, respectively.

### Comparison

**Flexibility**:
- `count` is straightforward but less flexible. It is ideal for creating a fixed number of identical resources.
- `for_each` is more flexible and can handle varying configurations, making it suitable for more complex scenarios.

**Resource Identification**:
- With `count`, instances are identified by an index (e.g., `aws_instance.example[0]`).
- With `for_each`, instances are identified by the keys of the map or set (e.g., `aws_instance.example["instance1"]`).

**Handling Dynamic Inputs**:
- `count` requires the number of instances to be known ahead of time.
- `for_each` can dynamically create resources based on the contents of a map or set, making it more adaptable to changing inputs.

### Conclusion

Both `count` and `for_each` are powerful tools in Terraform for managing multiple resources. The choice between them depends on the specific requirements of your infrastructure:

- Use `count` when you need a fixed number of identical resources.
- Use `for_each` when you need to create resources with unique configurations or when working with dynamic inputs.

By understanding the differences and use cases for `count` and `for_each`, you can more effectively manage and scale your Terraform configurations.

If you have any specific scenarios or need further clarification, feel free to ask!

## Variables
* Variables can be passed during the executing of apply command.
* variables can be passed to overrite default values.

```
 terraform plan -va="instance_type=t2.micro"
```


* variable precedence. command line is precedence

* Regualar
* Prompted
* From commandline
* Environment variables

* You can save the plan and reuse next time using below command



### Prompted

## From commandline

```sh
 terraform plan -var="instance_type=t2.mciro" -var="instance_count=3"
```

### Variable Definition Precedence
### Environment Variables
Environment variables must starts with TF_VAR_VARIABLE

```terraform
variable "region" {
  description = "This is the region where the infra should be created"
  default     = "us-east-1"
  type        = string
}

variable "instance_type" {
  description = "Instance type that is used in the infra"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "How many instances are needed"
  #default     = 1
  type = number
}

variable "ami_id" {
  type    = string
  default = "ami-04e5276ebb8451442"
}
```

 ```bash
# Environmental variables in linux
export TF_VAR_instance_count=2
export TF_VAR_instance_type=t2.micro

# Environmental variables in Windows
$env:TF_VAR_instance_count=2
$env:TF_VAR_instance_type="t2.micro"
 ```

### Save plan output and apply from plan
```sh
terraform plan -var="istance_type=t2.micro" -var="instance_count=3" -out myplan.out

terraform apply myplan.out
```
---
In Terraform, the concept of "prompted" variables refers to variables that are not provided directly in the configuration files, command line, or environment variables, but are instead prompted for interactively when you run `terraform plan` or `terraform apply`. These variables can be defined with a `type` and can include additional metadata such as a description, a default value, or validation rules.

### Defining Prompted Variables

To define a variable that Terraform will prompt for, you need to create a `variables.tf` file (or any `.tf` file) and define the variable without providing a default value or without overriding it in a `.tfvars` file or via other methods. 

### Example of Prompted Variable

Here's an example of defining a prompted variable:

```hcl
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
}
```

### Prompting for Variables

When you run `terraform plan` or `terraform apply`, Terraform will prompt you to enter values for these variables if they are not provided via other means (e.g., command line, `.tfvars` file, or environment variables).

### Running Terraform Commands

```sh
$ terraform plan
var.instance_count
  Number of instances to create

  Enter a value: 3

var.instance_type
  The type of instance to use

  Enter a value: t2.micro
```

### Overriding Prompted Variables

While prompted variables provide an interactive way to input values, you can override them using several methods to avoid prompts:

1. **Environment Variables**:
   ```sh
   export TF_VAR_instance_type=t2.micro
   export TF_VAR_instance_count=3
   terraform plan
   ```

2. **Command-Line Options**:
   ```sh
   terraform plan -var="instance_type=t2.micro" -var="instance_count=3"
   ```

3. **.tfvars File**:
   Create a `terraform.tfvars` file with the variable definitions:
   ```hcl
   instance_type = "t2.micro"
   instance_count = 3
   ```

4. **Auto-Loaded Variable Files**:
   Terraform will automatically load any `*.auto.tfvars` files in the current directory.

### Best Practices

- **Provide Descriptions**: Always provide descriptions for prompted variables to give context to the user when they are prompted.
- **Validation**: Use validation rules to ensure that the input meets certain criteria.
- **Sensitive Variables**: Use the `sensitive` attribute to prevent Terraform from showing the value in logs.
  
### Example with Validation and Sensitive

```hcl
variable "password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number

  validation {
    condition     = var.instance_count > 0
    error_message = "The instance count must be greater than 0"
  }
}
```

### Summary

- **Prompted Variables**: Defined without a default value or external override, causing Terraform to prompt the user for input.
- **Usage**: Useful for sensitive or configuration-specific values that should not be hardcoded or stored in files.
- **Overriding**: Can be overridden via environment variables, command-line options, or variable files.
- **Best Practices**: Provide descriptions, use validation, and mark sensitive variables appropriately.

By leveraging prompted variables, you can make your Terraform configurations more interactive and adaptable to different environments and use cases.

###  Terraform.tfvars

### Send from specific file

values come from by default by terraform.tfvars, in case you want to override from dev.tfvars, you need to mention that in command like below form.

```sh
terraform plan -var-file=dev.tfvars
```

terraform.tfvars
dev.tfvars # env.tfvars
dev.auto.tfvars # auto load the data, other than terraform.tfvars using env.auto.tfvars

### Variable Types

* string
* number
* boolean
* list
* maps

In Terraform, variables can be defined with specific types, including lists. A list is a sequence of values all of the same type. To define a variable of type list, you can use the `list` keyword followed by the type of the elements in the list, such as `list(string)` for a list of strings.

### Defining a List Variable

Here is how you can define and use a list variable in Terraform:

#### Example 1: List of Strings

**1. Define the List Variable in `variables.tf`:**

```hcl
variable "example_list" {
  description = "A list of example strings"
  type        = list(string)
  default     = ["example1", "example2", "example3"]
}
```

**2. Use the List Variable in `main.tf`:**

```hcl
resource "null_resource" "example" {
  count = length(var.example_list)

  provisioner "local-exec" {
    command = "echo ${var.example_list[count.index]}"
  }
}
```

In this example:
- `variables.tf` defines a variable `example_list` of type `list(string)` with a default value.
- `main.tf` uses the `example_list` variable in a resource, iterating over the list using the `count` parameter.

#### Example 2: List of Integers

**1. Define the List Variable in `variables.tf`:**

```hcl
variable "number_list" {
  description = "A list of numbers"
  type        = list(number)
  default     = [1, 2, 3, 4, 5]
}
```

**2. Use the List Variable in `main.tf`:**

```hcl
resource "null_resource" "number_example" {
  count = length(var.number_list)

  provisioner "local-exec" {
    command = "echo ${var.number_list[count.index]}"
  }
}
```

#### Example 3: List of Maps

If you need a more complex structure, such as a list of maps, you can define it as follows:

**1. Define the List of Maps Variable in `variables.tf`:**

```hcl
variable "list_of_maps" {
  description = "A list of maps"
  type = list(map(string))
  default = [
    {
      name = "example1"
      value = "value1"
    },
    {
      name = "example2"
      value = "value2"
    }
  ]
}
```

**2. Use the List of Maps Variable in `main.tf`:**

```hcl
resource "null_resource" "map_example" {
  count = length(var.list_of_maps)

  provisioner "local-exec" {
    command = "echo Name: ${var.list_of_maps[count.index]["name"]}, Value: ${var.list_of_maps[count.index]["value"]}"
  }
}
```

### Summary

- **Define a list variable**: Use the `variable` block with `type = list(TYPE)`.
- **Access list elements**: Use `var.variable_name[index]` to access individual elements.
- **Iterate over lists**: Use the `count` parameter in resources to iterate over list elements.

Using these techniques, you can define and utilize lists effectively in your Terraform configurations.

### Validations
There will be scenarios to validate variables, like amazon amiid has cerntain fomat to follow. we can validate such data.

Terraform provides a rich set of built-in functions that you can use to manipulate and transform data within your configuration files. These functions include string manipulation functions, numeric functions, collection functions, and more. Below is an overview of some commonly used string functions and other useful functions in Terraform.

Terraform validation helps ensure that the values provided for variables meet specific criteria before the configuration is applied. You can use the `validation` block within a `variable` block to define custom validation rules.

```terraform
 variable "ami_id" {
  description = "AMI ID needed for crating an EC2"
  type= string
  default = "dsami-04e5276ebb8451442"
  validation{
    condition = length(var.ami_id) > 4 && substr(var.ami_id, 0,4) == "ami-"
    error_message = "AMI ID should be valid and starts with ami-"
  }
 }
```

### Adding Validation Rules to Variables

Here is how you can add validation rules to a variable in Terraform:

#### Example 1: Validating a String Variable

**1. Define a String Variable with Validation in `variables.tf`:**

```hcl
variable "environment" {
  description = "The environment for deployment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of 'dev', 'staging', or 'prod'."
  }

  default = "dev"
}
```

In this example:
- The `validation` block ensures that the `environment` variable must be either `dev`, `staging`, or `prod`.
- If the condition is not met, the provided `error_message` will be displayed.

#### Example 2: Validating a List Variable

**1. Define a List Variable with Validation in `variables.tf`:**

```hcl
variable "regions" {
  description = "A list of AWS regions"
  type        = list(string)

  validation {
    condition     = alltrue([for region in var.regions : contains(["us-east-1", "us-west-1", "us-west-2"], region)])
    error_message = "All regions must be one of 'us-east-1', 'us-west-1', or 'us-west-2'."
  }

  default = ["us-east-1", "us-west-1"]
}
```

In this example:
- The `validation` block ensures that each element in the `regions` list must be one of `us-east-1`, `us-west-1`, or `us-west-2`.
- The `alltrue` function is used to validate all elements in the list.

#### Example 3: Validating a Number Variable

**1. Define a Number Variable with Validation in `variables.tf`:**

```hcl
variable "instance_count" {
  description = "The number of instances"
  type        = number

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "The instance count must be between 1 and 10."
  }

  default = 3
}
```

In this example:
- The `validation` block ensures that the `instance_count` variable must be between 1 and 10.
- If the condition is not met, the provided `error_message` will be displayed.

### Example of Complete Configuration with Validation

Here is a complete Terraform configuration that includes variables with validation rules:

```hcl
# variables.tf
variable "environment" {
  description = "The environment for deployment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment must be one of 'dev', 'staging', or 'prod'."
  }

  default = "dev"
}

variable "regions" {
  description = "A list of AWS regions"
  type        = list(string)

  validation {
    condition     = alltrue([for region in var.regions : contains(["us-east-1", "us-west-1", "us-west-2"], region)])
    error_message = "All regions must be one of 'us-east-1', 'us-west-1', or 'us-west-2'."
  }

  default = ["us-east-1", "us-west-1"]
}

variable "instance_count" {
  description = "The number of instances"
  type        = number

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "The instance count must be between 1 and 10."
  }

  default = 3
}

# main.tf
resource "aws_instance" "example" {
  count = var.instance_count

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "${var.environment}-instance"
  }
}

resource "aws_region" "example" {
  count = length(var.regions)

  region = var.regions[count.index]

  tags = {
    Name = "${var.environment}-region"
  }
}
```

### Summary

- **Validation Block**: Use the `validation` block within a `variable` block to define custom validation rules.
- **Condition and Error Message**: The `condition` argument specifies the validation rule, and the `error_message` argument provides a message to be displayed if the condition is not met.
- **Functions**: Use functions like `contains`, `alltrue`, and conditional expressions to build complex validation rules.

By adding validation rules, you can ensure that the input values for your variables meet specific criteria, helping to prevent configuration errors.

### String Functions

#### 1. `format`
Formats a string with the given values.

```hcl
variable "name" {
  default = "world"
}

output "greeting" {
  value = format("Hello, %s!", var.name)
}
```

#### 2. `join`
Joins a list of strings into a single string with a given separator.

```hcl
variable "list_of_strings" {
  default = ["one", "two", "three"]
}

output "joined_string" {
  value = join(", ", var.list_of_strings)
}
```

#### 3. `split`
Splits a string into a list of substrings using a given separator.

```hcl
variable "comma_separated_string" {
  default = "one,two,three"
}

output "split_list" {
  value = split(",", var.comma_separated_string)
}
```

#### 4. `lower`
Converts a string to lowercase.

```hcl
variable "mixed_case_string" {
  default = "Hello World"
}

output "lowercase_string" {
  value = lower(var.mixed_case_string)
}
```

#### 5. `upper`
Converts a string to uppercase.

```hcl
variable "mixed_case_string" {
  default = "Hello World"
}

output "uppercase_string" {
  value = upper(var.mixed_case_string)
}
```

#### 6. `replace`
Replaces all occurrences of a substring with another string.

```hcl
variable "original_string" {
  default = "Hello, world!"
}

output "replaced_string" {
  value = replace(var.original_string, "world", "Terraform")
}
```

#### 7. `trimspace`
Removes leading and trailing whitespace from a string.

```hcl
variable "string_with_spaces" {
  default = "  Hello, world!  "
}

output "trimmed_string" {
  value = trimspace(var.string_with_spaces)
}
```

### Numeric Functions

#### 1. `max`
Returns the maximum value from the given arguments.

```hcl
output "max_value" {
  value = max(1, 2, 3, 4, 5)
}
```

#### 2. `min`
Returns the minimum value from the given arguments.

```hcl
output "min_value" {
  value = min(1, 2, 3, 4, 5)
}
```

### Collection Functions

#### 1. `length`
Returns the number of elements in a collection or the number of characters in a string.

```hcl
variable "list_of_strings" {
  default = ["one", "two", "three"]
}

output "list_length" {
  value = length(var.list_of_strings)
}
```

#### 2. `element`
Returns the element at the given index in a list.

```hcl
variable "list_of_strings" {
  default = ["one", "two", "three"]
}

output "second_element" {
  value = element(var.list_of_strings, 1) # "two"
}
```

#### 3. `contains`
Returns true if a list contains a given value.

```hcl
variable "list_of_strings" {
  default = ["one", "two", "three"]
}

output "contains_two" {
  value = contains(var.list_of_strings, "two")
}
```

#### 4. `merge`
Merges two or more maps into a single map.

```hcl
variable "map1" {
  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

variable "map2" {
  default = {
    key2 = "override"
    key3 = "value3"
  }
}

output "merged_map" {
  value = merge(var.map1, var.map2)
}
```

### Conditional Functions

#### 1. `coalesce`
Returns the first non-null argument.

```hcl
variable "val1" {
  default = null
}

variable "val2" {
  default = "non-null"
}

output "first_non_null" {
  value = coalesce(var.val1, var.val2, "default")
}
```

### Example: Combining Functions

You can combine multiple functions to achieve complex transformations. Here's an example:

```hcl
variable "input_string" {
  default = "  Hello, Terraform!  "
}

output "processed_string" {
  value = upper(trimspace(replace(var.input_string, "Terraform", "World")))
}
```

In this example:
- `replace` changes "Terraform" to "World".
- `trimspace` removes leading and trailing whitespace.
- `upper` converts the string to uppercase.

### Summary

Terraform provides a wide range of built-in functions that you can use to manipulate strings, numbers, collections, and more. By combining these functions, you can perform complex transformations and validations within your configuration files. The [Terraform documentation](https://www.terraform.io/docs/language/functions/index.html) provides a comprehensive list of all available functions and their usage.

Terraform provides several constructs for implementing conditional logic and loops within your configurations. These include `count`, `for_each`, `for`, `if`, `else`, and the ternary operator. Here’s an overview of how to use these constructs effectively.

### Conditional Logic

#### 1. `count`
The `count` parameter allows you to specify the number of instances of a resource to create based on a condition.

```hcl
variable "create_instance" {
  default = true
}

resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0

  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

In this example:
- If `create_instance` is `true`, Terraform will create one instance. Otherwise, it will create zero instances.

#### 2. Conditional Expressions (Ternary Operator)
Conditional expressions allow you to assign values based on a condition.

```hcl
variable "environment" {
  default = "dev"
}

output "instance_type" {
  value = var.environment == "prod" ? "m5.large" : "t2.micro"
}
```

In this example:
- The `instance_type` output will be `m5.large` if `environment` is `prod`, otherwise, it will be `t2.micro`.

### Loops

#### 1. `for_each`
The `for_each` meta-argument allows you to iterate over a map or set of strings to create multiple instances of a resource.

```hcl
variable "users" {
  default = {
    user1 = "John"
    user2 = "Jane"
  }
}

resource "aws_iam_user" "example" {
  for_each = var.users

  name = each.value
}
```

In this example:
- Terraform will create an IAM user for each key-value pair in the `users` variable.

#### 2. `for` Expressions
`for` expressions allow you to transform collections using a for-loop style syntax.

**Example 1: Transform a List**

```hcl
variable "names" {
  default = ["Alice", "Bob", "Charlie"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}
```

In this example:
- The `upper_names` output will be a list of names in uppercase.

**Example 2: Filter and Transform a List**

```hcl
variable "names" {
  default = ["Alice", "Bob", "Charlie"]
}

output "filtered_upper_names" {
  value = [for name in var.names : upper(name) if length(name) > 3]
}
```

In this example:
- The `filtered_upper_names` output will include only names longer than 3 characters, converted to uppercase.

### Combining Conditionals and Loops

You can combine conditional logic and loops to create more complex configurations.

**Example: Creating Resources Based on Conditions and Loops**

```hcl
variable "create_resources" {
  default = true
}

variable "servers" {
  default = ["server1", "server2"]
}

resource "aws_instance" "example" {
  count = var.create_resources ? length(var.servers) : 0

  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = var.servers[count.index]
  }
}
```

In this example:
- If `create_resources` is `true`, Terraform will create an instance for each server name in the `servers` list. Otherwise, no instances will be created.

### Example: Using `for_each` with Conditional Logic

You can also use `for_each` with conditional logic to selectively create resources.

```hcl
variable "environments" {
  default = {
    dev  = "Development"
    prod = "Production"
  }
}

variable "deploy_to_prod" {
  default = false
}

resource "aws_s3_bucket" "example" {
  for_each = var.deploy_to_prod ? var.environments : { dev = var.environments["dev"] }

  bucket = "${each.key}-bucket"
  tags = {
    Environment = each.value
  }
}
```

In this example:
- If `deploy_to_prod` is `true`, Terraform will create S3 buckets for both `dev` and `prod` environments. Otherwise, it will only create the bucket for the `dev` environment.

### Summary

- **Conditional Logic**: Use `count`, conditional expressions, and the ternary operator to create resources based on conditions.
- **Loops**: Use `for_each` and `for` expressions to iterate over and transform collections.
- **Combining Constructs**: You can combine conditional logic and loops to create complex resource configurations.

These constructs allow you to create flexible and dynamic Terraform configurations that can adapt to different scenarios and requirements.

---
### There are number of ways to pass variables at runtime
In Terraform, you can pass variable values at runtime using several methods. This flexibility allows you to choose the most suitable method for your use case. Here are the main ways to pass variable values at runtime:

### 1. Command-Line Flags

You can pass variable values directly in the command line when running `terraform apply` or `terraform plan` using the `-var` flag.

```sh
terraform apply -var="variable_name=value"
```

For example:

```sh
terraform apply -var="instance_type=t2.micro"
```

### 2. Variable Definition Files (`.tfvars` files)

You can create a file with the `.tfvars` extension to define variable values. Terraform will automatically load this file if it's named `terraform.tfvars` or `*.auto.tfvars`. You can also specify a custom file using the `-var-file` flag.

**Example: `terraform.tfvars`**

```hcl
instance_type = "t2.micro"
```

**Example: Custom Variable Definition File**

Create a file named `custom.tfvars`:

```hcl
instance_type = "t2.micro"
```

Then, run the command:

```sh
terraform apply -var-file="custom.tfvars"
```

### 3. Environment Variables

Terraform allows you to set environment variables to pass variable values. The environment variables should be prefixed with `TF_VAR_`.

```sh
export TF_VAR_instance_type="t2.micro"
terraform apply
```

### 4. Terraform Cloud/Enterprise Variables

If you are using Terraform Cloud or Enterprise, you can set variable values directly in the workspace settings. This is useful for managing sensitive values and environment-specific configurations centrally.

### 5. Input Prompts

If a variable is defined without a default value and no value is provided via the methods above, Terraform will prompt you to enter a value interactively.

**Example: `variables.tf`**

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}
```

When running `terraform apply`, you will be prompted:

```sh
$ terraform apply
var.instance_type
  Type of EC2 instance

  Enter a value: t2.micro
```

### 6. Terraform Configuration Files (`.tf` files)

You can define default values for variables directly in your `.tf` files. These default values will be used if no other values are provided.

**Example: `variables.tf`**

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
```

### Summary

Here’s a summary of the different ways to pass variable values at runtime in Terraform:

1. **Command-Line Flags**: Use `-var` flag to pass variable values directly in the command line.
2. **Variable Definition Files**: Use `.tfvars` files to define variable values, either automatically loaded or specified using `-var-file` flag.
3. **Environment Variables**: Set environment variables with `TF_VAR_` prefix to pass variable values.
4. **Terraform Cloud/Enterprise Variables**: Set variable values in the workspace settings when using Terraform Cloud or Enterprise.
5. **Input Prompts**: Terraform will prompt for input if no value is provided and no default value is set.
6. **Configuration Files**: Define default values for variables directly in your Terraform configuration files.

These methods provide flexibility in how you manage and pass variable values, making Terraform adaptable to various workflows and environments.

## Output variables

output variables are similar to return types in programming languages.

```terraform
  output "public_ip_op" {
      description = "EC2 Machine Public IP"
      value = aws_instance.tf-ec2.public_ip
  }

  output "List_of_SG" {
      description = "Listing the SG's used for the EC2 machine"
      value = aws_instance.tf-ec2.vpc_security_groups
  }

  output "public_dns_op" {
      value = "http://${aws_instance.tf-ec2.public_dns}"
  }
```

* these output values can be passed to ansible.

## Local Variables

A local values assigns a name to expression, so you can use the name multiple times within a module instead of repeating the expression

* Input Variables: Used to pass dynamic values into the configuration from outside.
* Local Variables: Used to define reusable values within a module.


In Terraform, sensitive variables are used to handle sensitive information such as passwords, API keys, tokens, and other secrets. Marking a variable as sensitive ensures that its value is not displayed in the Terraform CLI output, logs, or state files in plaintext, thereby enhancing security and preventing accidental exposure of sensitive data.

```terraform
    output "public_ip_op" {
      description = "EC2 Machine Public IP"
      value = aws_instance.tf-ec2.public_ip
  }

  output "List_of_SG" {
      description = "Listing the SG's used for the EC2 machine"
      value = aws_instance.tf-ec2.vpc_security_groups
  }

  output "public_dns_op" {
      value = "http://${aws_instance.tf-ec2.public_dns}"
  }
```

### Declaring Sensitive Variables

To mark a variable as sensitive, you use the `sensitive` argument within the `variable` block.

**Example**:
```hcl
variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
```

### Using Sensitive Variables

When you use a sensitive variable in your Terraform configuration, Terraform ensures that the sensitive value is redacted in the CLI output.

**Example**:
```hcl
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

resource "aws_db_instance" "example" {
  identifier = "my-db-instance"
  engine     = "mysql"
  username   = "admin"
  password   = var.db_password  # Sensitive variable
  db_subnet_group_name = "my-subnet-group"

  # Additional arguments
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}
```

### Key Points About Sensitive Variables

1. **Redaction in Output**: Terraform redacts sensitive variable values in the output. For example, if a sensitive variable is referenced in a `terraform plan` or `terraform apply` output, Terraform will display `(sensitive value)` instead of the actual value.

2. **State File Security**: While Terraform does not encrypt sensitive values in the state file, marking variables as sensitive helps you be cautious about their handling. It is recommended to use secure backends (e.g., Terraform Cloud, AWS S3 with encryption) for storing state files.

3. **Environment Variables**: When passing sensitive variables through environment variables, ensure that these environment variables are managed securely to avoid exposure.

4. **Sensitive Data Handling**: Marking variables as sensitive does not eliminate the need to handle sensitive data securely in other aspects of your infrastructure. Ensure that you follow best practices for securing credentials and secrets throughout your workflow.

### Example with `output` Block

When you output sensitive values, you should also mark the output as sensitive to prevent accidental exposure.

```hcl
output "db_password" {
  value     = var.db_password
  sensitive = true
}
```

### Security Best Practices

1. **Use Secret Management Tools**: Integrate Terraform with secret management tools like HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault to securely manage and inject secrets into your Terraform configurations.

2. **Secure State Storage**: Store your Terraform state files in a secure and encrypted backend to protect sensitive data contained in the state.

3. **Limit Access**: Restrict access to sensitive variables and state files to only those who need it. Implement role-based access controls (RBAC) where possible.

4. **Audit and Monitoring**: Regularly audit access to sensitive variables and monitor for any unauthorized access or exposure.

### Conclusion

Sensitive variables in Terraform provide a way to manage and protect sensitive information, ensuring it is not inadvertently exposed in CLI output or logs. By marking variables as sensitive and following best practices for secret management, you can enhance the security of your Terraform configurations and protect critical data.

