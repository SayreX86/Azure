$RG = 'RG4'
Login-AzureRmAccount
New-AzureRmResourceGroup -Name $RG -Location westeurope -Force -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG `
-TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.json' `
-TemplateParameterFile 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.parameters.json' `
-Force -Verbose