* Schema & ContentVersion
* parameters
* variables
* resources
* outputs

* ARM template we can't create resource group. Resource group must exist upfront.

powersehll:
New-AzResourceGroup -Name Test-RG01 -Location EastUS
New-AZResourceGroupDeployment -ResourceGroupName Test-RG01 -TemplateFile D:\azuredeploy.json -TemplateParameterFile D:\azuredeploy.parameters.json

Azure Devops:
   Organization -> Project -> Teams
   Key concepts: https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops