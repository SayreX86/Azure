$RG = 'RG3'
Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG `
-TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.json' `
-TemplateParameterUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.parameters.json' `
-Force -Verbose