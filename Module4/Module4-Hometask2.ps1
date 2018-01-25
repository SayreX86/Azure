$RG = 'RG'
Login-AzureRmAccount
New-AzureRmResourceGroup -Name $RG -Location westeurope -Verbose
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG -TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module3/main.json' -Verbose