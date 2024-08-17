PR Pipeline
Variables
DotNetCoreCLI@2


- Stages
  - Stage
    - jobs
      - job
        -  steps
           -  step/script

# https://learn.microsoft.com/en-us/azure/devops/pipelines/architectures/devops-pipelines-baseline-architecture?view=azure-devops

# https://learn.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch

conditions and dependencies
deployment job
Stages
jobs
steps
tasks/scripts

Jobs:
  1. Agent pool jobs
  2. Server jobs
  3. Container jobs

## Agent pool jobs

Demands and capabilities are designed for use with self-hosted agents so that jobs can be matched with an agent that meets the requirements of the job. When using Microsoft-hosted agents, you select an image for the agent that matches the requirements of the job, so although it is possible to add capabilities to a Microsoft-hosted agent, you don't need to use capabilities with Microsoft-hosted agents.

```yaml
  pool:
  name: myPrivateAgents    # your job runs on an agent in this pool
  demands: agent.os -equals Windows_NT    # the agent must have this capability to run the job
steps:
- script: echo hello world
```

* you can choose multiple demands (multiple capabilities)

[jobs](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/phases?view=azure-devops&tabs=yaml)


## Conditions
You can specify the conditions under which each job runs. By default, a job runs if it doesn't depend on any other job, or if all of the jobs that it depends on have completed and succeeded. You can customize this behavior by forcing a job to run even if a previous job fails or by specifying a custom condition.

In Azure DevOps Pipelines, the structure of a pipeline is defined hierarchically, and understanding the relationship between **stages**, **jobs**, **steps**, **scripts**, and **tasks** is key to creating effective CI/CD workflows.

### **1. Stages**
- **Stages** are the top-level containers that define major phases of your pipeline, such as "Build", "Test", and "Deploy". 
- **Stages** can run sequentially or in parallel, and each stage can have its own set of jobs, environment, and conditions.
- **Stages** are useful for organizing a pipeline into logical sections and for controlling when different parts of the pipeline should execute.

```yaml
stages:
- stage: Build
  jobs:
  - job: BuildJob
    steps:
    - script: echo "Building..."
```

### **2. Jobs**
- **Jobs** are containers within a stage that run on an agent and perform a set of tasks or steps.
- **Jobs** run in parallel by default within a stage, but you can control their order using dependencies.
- A **job** contains multiple steps, which are executed sequentially.

```yaml
stages:
- stage: Build
  jobs:
  - job: BuildJob1
    steps:
    - script: echo "Building Job 1..."
  - job: BuildJob2
    steps:
    - script: echo "Building Job 2..."
```

### **3. Steps**
- **Steps** are the smallest units of work within a job. Each step runs in sequence within the job.
- **Steps** can be scripts, tasks, or other predefined activities (e.g., downloading artifacts, checking out source code).
- Steps execute in the order they are defined within the job.

```yaml
jobs:
- job: BuildJob
  steps:
  - script: echo "This is step 1"
  - script: echo "This is step 2"
```

### **4. Scripts**
- **Scripts** are a specific type of step that allows you to run shell or PowerShell commands directly in your pipeline.
- This can be used for custom commands or actions that are not covered by built-in tasks.

```yaml
steps:
- script: echo "Hello, World!"
```

### **5. Tasks**
- **Tasks** are predefined actions provided by Azure DevOps or custom extensions that perform specific actions, like building a .NET project, running tests, or deploying to Azure.
- Tasks are also steps in a job, but they provide more structured and reusable functionality compared to scripts.

```yaml
steps:
- task: DotNetCoreCLI@2
  inputs:
    command: 'build'
    projects: '**/*.csproj'
```

### **Hierarchy Summary:**

1. **Stages**: Define the high-level workflow of your pipeline. Each stage can contain multiple jobs.
2. **Stage**: A specific instance of a stage.
3. **Jobs**: Define the tasks that will be executed on an agent. Each job can contain multiple steps.
4. **Job**: A specific instance of a job.
5. **Steps**: Define the sequence of actions within a job. Steps can be scripts or tasks.
6. **Step**: A specific instance of a step.
7. **Scripts**: Specific commands or scripts executed as steps within a job.
8. **Tasks**: Predefined or custom actions executed as steps within a job.

### **Example of Full Hierarchy in YAML:**

```yaml
stages:
- stage: BuildStage
  jobs:
  - job: BuildJob
    steps:
    - script: echo "Building the project..."  # Script Step
    - task: DotNetCoreCLI@2                  # Task Step
      inputs:
        command: 'build'
        projects: '**/*.csproj'

- stage: DeployStage
  jobs:
  - job: DeployJob
    steps:
    - script: echo "Deploying the application..."
    - task: AzureWebApp@1
      inputs:
        appName: 'my-app'
        package: '$(Build.ArtifactStagingDirectory)/drop'
```

### **Relationships:**

- **Stages** contain one or more **jobs**.
- **Jobs** contain one or more **steps**.
- **Steps** can either be **scripts** or **tasks**.

### **Conclusion:**
Understanding the hierarchy of **stages**, **jobs**, **steps**, **scripts**, and **tasks** in Azure DevOps Pipelines allows you to design and organize complex CI/CD pipelines effectively. By breaking down your pipeline into these components, you can control execution order, parallelism, and reuse common tasks across different parts of the pipeline.
---
## List style variables
In the list syntax of variable declaration in Azure DevOps YAML pipelines, you can define several additional attributes to control how variables behave. These attributes provide more flexibility, particularly when dealing with secrets or when needing to control variable behavior across different pipeline scopes.

```yml
variables:
  - name: myvariable
    value: myvalue
    allowOverride: true
    readonly: false

  - name: mySecretVariable
    value: $(mySecretValue)
    isSecret: true

  - name: myScopedVariable
    value: scopedValue
    scope: JobName

  - name: expandedVariable
    value: $(otherVariable)
    expanded: true
```

### **Explanation of the Example:**

- **`myvariable`**: A regular variable with `allowOverride` set to `true`, meaning it can be overridden later in the pipeline.
- **`mySecretVariable`**: A secret variable that masks its value in the logs.
- **`myScopedVariable`**: A variable that is scoped to a specific job (`JobName`), meaning it's only accessible within that job.
- **`expandedVariable`**: A variable that will expand `$(otherVariable)` to its actual value before use.
---
### Wild card
Azure DevOps pipelines support various wildcard characters in tasks, steps, and scripts, particularly when dealing with file paths, project files, or other patterns. These wildcards help simplify file selection and pattern matching. Below are the commonly used wildcard characters and their meanings:

### **1. Asterisk (`*`)**
   - **Meaning**: Matches zero or more characters within a single directory level.
   - **Use Cases**: 
     - Select all files with a specific extension.
     - Match any characters within a filename or directory.
   - **Examples**:
     - `*.csproj`: Matches all `.csproj` files in the current directory.
     - `src/*`: Matches all files and directories directly under the `src` directory.

### **2. Double Asterisk (`**`)**
   - **Meaning**: Recursively matches directories and files at any depth.
   - **Use Cases**: 
     - Select files across multiple subdirectories.
     - Capture files across an entire directory tree.
   - **Examples**:
     - `**/*.cs`: Matches all `.cs` files in the current directory and all subdirectories.
     - `src/**/*.dll`: Matches all `.dll` files within the `src` directory and all its subdirectories.

### **3. Question Mark (`?`)**
   - **Meaning**: Matches exactly one character.
   - **Use Cases**: 
     - Replace a single character within a file or directory name.
   - **Examples**:
     - `file?.txt`: Matches files like `file1.txt`, `fileA.txt`, but not `file12.txt`.
     - `src/dir?`: Matches directories like `src/dir1`, `src/dirA`.

### **4. Square Brackets (`[]`)**
   - **Meaning**: Matches any one of the characters enclosed in the brackets.
   - **Use Cases**: 
     - Match specific characters in a file or directory name.
   - **Examples**:
     - `file[1-3].txt`: Matches `file1.txt`, `file2.txt`, and `file3.txt`.
     - `src/file[ab].cs`: Matches `src/filea.cs` and `src/fileb.cs`.

### **5. Exclamation Mark (`!`)**
   - **Meaning**: Excludes files or directories from a pattern.
   - **Use Cases**: 
     - Exclude specific files or directories from being selected.
   - **Examples**:
     - `!**/test/**`: Excludes any files within directories named `test`.
     - `!src/**/*.json`: Excludes all `.json` files within the `src` directory and its subdirectories.

### **Using Wildcards in Azure DevOps Pipeline Tasks**

You can use these wildcard characters in various tasks like `CopyFiles`, `PublishBuildArtifacts`, and `VSBuild` to specify the files to include or exclude.

- **CopyFiles Example**:
  ```yaml
  - task: CopyFiles@2
    inputs:
      SourceFolder: 'src'
      Contents: '**/*.dll'  # Copies all DLL files from all subdirectories
      TargetFolder: 'output'
  ```

- **PublishBuildArtifacts Example**:
  ```yaml
  - task: PublishBuildArtifacts@1
    inputs:
      pathToPublish: 'bin/**/*.zip'  # Publishes all ZIP files in the bin directory and subdirectories
      artifactName: 'drop'
  ```

- **VSBuild Example**:
  ```yaml
  - task: VSBuild@1
    inputs:
      solution: '**/*.sln'  # Builds all solution files in the repository
  ```

### **Combining Wildcards**

You can combine different wildcard characters for more complex pattern matching.

- **Example**:
  ```yaml
  - task: CopyFiles@2
    inputs:
      SourceFolder: 'src'
      Contents: '**/[!test]*.dll'  # Copies all DLL files excluding those starting with 'test'
      TargetFolder: 'output'
  ```

### **Notes**:
- Wildcards can be powerful but be cautious of unintentional matches, especially when using recursive patterns (`**`).
- Some tasks or script interpreters may handle wildcards slightly differently, so always test your patterns to ensure they work as expected in your pipeline environment.

### **Conclusion**

Wildcards in Azure DevOps pipelines provide flexibility for file and directory selection in tasks and steps. Understanding how to use `*`, `**`, `?`, `[]`, and `!` can help you manage files and directories efficiently in your CI/CD workflows.


---
### Shell scripting wild card 
In shell scripting (e.g., Bash), wildcard characters (also known as globbing patterns) are used to match file names or paths. They are a powerful tool for selecting groups of files or directories that match specific patterns. Below are the most commonly used wildcard characters in shell scripting:

### **1. Asterisk (`*`)**
   - **Meaning**: Matches zero or more characters in a file or directory name.
   - **Use Cases**: 
     - Select all files with a specific extension.
     - Match any characters within a filename or directory.
   - **Examples**:
     - `*.txt`: Matches all files ending with `.txt` (e.g., `file.txt`, `notes.txt`).
     - `file*`: Matches `file`, `file1`, `fileA`, and `fileXYZ`.
     - `dir/*`: Matches all files and directories directly under `dir`.

### **2. Question Mark (`?`)**
   - **Meaning**: Matches exactly one character in a file or directory name.
   - **Use Cases**: 
     - Replace a single character within a file or directory name.
   - **Examples**:
     - `file?.txt`: Matches `file1.txt`, `fileA.txt`, but not `file12.txt`.
     - `d?r`: Matches `dir`, `dar`, but not `daar`.

### **3. Square Brackets (`[]`)**
   - **Meaning**: Matches any one of the characters enclosed in the brackets.
   - **Use Cases**: 
     - Match specific characters in a file or directory name.
     - Define a range of characters.
   - **Examples**:
     - `file[1-3].txt`: Matches `file1.txt`, `file2.txt`, and `file3.txt`.
     - `file[abc].txt`: Matches `filea.txt`, `fileb.txt`, and `filec.txt`.
     - `file[!a].txt`: Matches `fileb.txt`, `filec.txt`, but not `filea.txt`.

### **4. Exclamation Mark (`!`)**
   - **Meaning**: Negates the pattern, matching files that do not contain the specified characters. Typically used within square brackets.
   - **Use Cases**: 
     - Exclude specific characters in a file or directory name.
   - **Examples**:
     - `file[!0-9].txt`: Matches any `.txt` file where the character at the wildcard position is not a digit.
     - `file[!a].txt`: Matches files that do not have `a` in the specified position.

### **5. Curly Braces (`{}`)**
   - **Meaning**: Matches any of the comma-separated patterns inside the braces.
   - **Use Cases**: 
     - Match multiple specific patterns in a file or directory name.
   - **Examples**:
     - `file{1,2,3}.txt`: Matches `file1.txt`, `file2.txt`, and `file3.txt`.
     - `file{A,B,C}.txt`: Matches `fileA.txt`, `fileB.txt`, and `fileC.txt`.

### **6. Double Asterisk (`**`)**
   - **Meaning**: Recursively matches directories and files at any depth.
   - **Use Cases**: 
     - Select files across multiple subdirectories.
   - **Examples**:
     - `dir/**/*.txt`: Matches all `.txt` files in `dir` and all of its subdirectories.

### **7. Escaping Wildcards (`\`)**
   - **Meaning**: Prevents a wildcard from being treated as a special character.
   - **Use Cases**: 
     - When you want to use the wildcard character literally.
   - **Examples**:
     - `\*.txt`: Matches a file named `*.txt`, not all `.txt` files.

### **8. Combining Wildcards**

You can combine these wildcard characters for more complex pattern matching.

- **Examples**:
  - `file[1-3]?.{txt,csv}`: Matches `file1a.txt`, `file2b.csv`, etc.
  - `dir*/**/*.sh`: Matches all `.sh` files in any directory that starts with `dir` and its subdirectories.

### **Using Wildcards in Shell Commands**

Wildcards are frequently used in commands like `ls`, `cp`, `mv`, `rm`, etc.

- **List files**:
  ```bash
  ls *.txt
  ```
  Lists all `.txt` files in the current directory.

- **Copy files**:
  ```bash
  cp *.txt /backup/
  ```
  Copies all `.txt` files to the `/backup/` directory.

- **Remove files**:
  ```bash
  rm file[1-3].txt
  ```
  Removes `file1.txt`, `file2.txt`, and `file3.txt`.

### **Examples of Wildcard Usage**

#### **1. Matching All Files with a Specific Extension:**
```bash
ls *.jpg
```
This command lists all files in the current directory that end with `.jpg`.

#### **2. Matching Files with a Single Character Difference:**
```bash
ls file?.txt
```
This command lists files like `file1.txt`, `fileA.txt`, but not `file12.txt`.

#### **3. Matching Files with Multiple Specific Characters:**
```bash
ls file[1-3].txt
```
This command lists `file1.txt`, `file2.txt`, and `file3.txt`.

#### **4. Recursive File Matching:**
```bash
ls **/*.txt
```
This command lists all `.txt` files in the current directory and all subdirectories.

### **Conclusion**

Wildcards in shell scripting allow you to work with multiple files and directories easily by matching patterns rather than specifying each item individually. Understanding and effectively using wildcards can make shell scripting more powerful and flexible, especially when dealing with file operations.
---

```yaml
    # Two examples of expressions used to define variables
    # The first one, a, is evaluated when the YAML file is compiled into a plan.
    # The second one, b, is evaluated at runtime.
    # Note the syntax ${{}} for compile time and $[] for runtime expressions.
    variables:
    a: ${{ <expression> }}
    b: $[ <expression> ]
```
The difference between runtime and compile time expression syntaxes is primarily what context is available. In a compile-time expression (${{ <expression> }}), you have access to parameters and statically defined variables. In a runtime expression ($[ <expression> ]), you have access to more variables but no parameters.

In this example, a runtime expression sets the value of $(isMain). A static variable in a compile expression sets the value of $(compileVar).

```
variables:
  staticVar: 'my value' # static variable
  compileVar: ${{ variables.staticVar }} # compile time expression
  isMain: $[eq(variables['Build.SourceBranch'], 'refs/heads/main')] # runtime expression

steps:
  - script: |
      echo ${{variables.staticVar}} # outputs my value
      echo $(compileVar) # outputs my value
      echo $(isMain) # outputs True
```

### Functions
* and
* convertToJson
* containsValue
* contains
* coalesce
* counter
* endsWith -- Example: endsWith('ABCDE', 'DE') (returns True)
* eq -- Example: eq(variables.letters, 'ABC')
* ge -- Example: ge(5, 5) (returns True)
* gt -- Example: gt(5, 2) (returns True)
* in -- Example: in('B', 'A', 'B', 'C') (returns True)
* format
* join -- 
* le
* length
* lt
* ne
* not
* notIn
* or
* replace
* split
* startsWith
* upper
* Xor
[Functios](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/expressions?
view=azure-devops)

### Join Example

In this example, a semicolon gets added between each item in the array. The parameter type is an object.

```yaml
parameters:
- name: myArray
  type: object
  default:
    - FOO
    - BAR
    - ZOO

variables:
   A: ${{ join(';',parameters.myArray) }}

steps:
  - script: echo $A # outputs FOO;BAR;ZOO
```
* pipeline.startTime

### Job Status check functions

* always
* canceled
* failed
* succeeded
* succeededOrFailed

### Conditional insertion

* Conditionally assign a variable
* Conditionally set a task input
```yaml
pool:
  vmImage: 'ubuntu-latest'

steps:
- task: PublishPipelineArtifact@1
  inputs:
    targetPath: '$(Pipeline.Workspace)'
    ${{ if eq(variables['Build.SourceBranchName'], 'main') }}:
      artifact: 'prod'
    ${{ else }}:
      artifact: 'dev'
    publishLocation: 'pipeline'
```

### Conditionally run a step

If there's no variable set, or the value of foo doesn't match the if conditions, the else statement runs. Here the value of foo returns true in the elseif condition.

```yaml
variables:
  - name: foo
    value: contoso # triggers elseif condition

pool:
  vmImage: 'ubuntu-latest'

steps:
- script: echo "start"
- ${{ if eq(variables.foo, 'adaptum') }}:
  - script: echo "this is adaptum"
- ${{ elseif eq(variables.foo, 'contoso') }}: # true
  - script: echo "this is contoso" 
- ${{ else }}:
  - script: echo "the value is not adaptum or contoso"
  ```

  ### each
  ### Dependencies
  Expressions can use the dependencies context to reference previous jobs or stages. You can use dependencies to:

* Reference the job status of a previous job
* Reference the stage status of a previous stage
* Reference output variables in the previous job in the same stage
* Reference output variables in the previous stage in a stage
* Reference output variables in a job in a previous stage in the following stage

### Filtered arrays
### Type casting