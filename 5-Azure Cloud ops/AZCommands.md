

### Key Differences Between Arguments and Global Arguments:
| Aspect                   | **Arguments**                                         | **Global Arguments**                                |
|--------------------------|------------------------------------------------------|-----------------------------------------------------|
| **Scope**                 | Specific to individual commands.                     | Available across all Azure CLI commands.            |
| **Purpose**               | Define inputs, actions, or configuration for a specific command. | Control how the Azure CLI behaves or formats output. |
| **Examples**              | `--name`, `--resource-group`, `--image` for a VM command. | `--output`, `--verbose`, `--subscription`.           |
| **Usage**                 | Varies from command to command.                      | Can be used with any command.                       |
| **Affects**               | Resources or tasks like creating, listing, or updating Azure services. | CLI behavior like output format, verbosity, or subscription. |

### Summary:
- **Arguments** are tied to specific Azure CLI commands and provide the necessary input for managing Azure resources.
- **Global Arguments** apply to all Azure CLI commands and control how the CLI behaves or formats the output.

By combining both types of arguments, you can customize Azure CLI commands to meet specific needs and control their behavior effectively.

### Search
  - Using grep

  ```
    az resource list --output table | grep -E "myVM|production"
  ```
  - jq 

        # Get resources by name
        az resource list --name myVM --output json > resources_by_name.json

        # Get resources by tag
        az resource list --tag environment=production --output json > resources_by_tag.json

        # Combine the two results
        cat resources_by_name.json resources_by_tag.json | jq -s 'add | unique_by(.id)' > combined_resources.json


### Output Format

#### Common Global Arguments:
- `--help`: Display help information about the command.
- `--output` (`-o`): Set the output format (e.g., `json`, `table`, `tsv`, etc.).
- `--verbose`: Increase verbosity of output to show more details about what’s happening.
- `--debug`: Show all the details of CLI operations, including HTTP requests.
- `--query`: Filter output using the JMESPath query language.
- `--subscription`: Specify which Azure subscription to use for the command.
- `--only-show-errors`: Only show errors if any occur, suppressing non-error messages.
- `--no-wait`: Don’t wait for the long-running operation to complete.
- `--yes` (`-y`): Answer "yes" to prompts automatically.
