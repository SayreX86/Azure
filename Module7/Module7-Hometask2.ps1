$RG = 'RG3'
Login-AzureRmAccount
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG `
-TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.json' `
-TemplateParameterUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module7/vault.parameters.json' `
-Force -Verbose

$s = Get-AzureRmSubscription | Out-GridView -PassThru -Title "Select subscription"
Set-AzureRmContext -SubscriptionId $s.SubscriptionId
New-AzureRmResourceGroup -Name $RG2 -Location $Location -Force -Verbose

<#
$backupsacheck = Get-AzureRmStorageAccount | Where-Object {$_.StorageAccountName -eq 'backupsatraining'}
if ($backupsacheck -eq $null) {
    Write-Host "Creating backupsatraining storage account..." -BackgroundColor DarkCyan
    New-AzureRmStorageAccount -ResourceGroupName $RG -Name 'backupsatraining' -SkuName Standard_LRS -Location westeurope
}
else {
    Write-Host "Storage account backupsa already exist!" -BackgroundColor DarkCyan
}
#>