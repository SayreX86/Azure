$RG = 'RG'
$RG2 = 'RG2'
$StorageName = 'sascriptstraining'
$Location = 'westeurope'
$DSCConfigPath = 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module4/MyDsc.ps1'
$TempDSCCOnfigPath = "$env:TEMP\MyDsc.ps1"
Login-AzureRmAccount
New-AzureRmResourceGroup -Name $RG2 -Location $Location -Force -Verbose
#Create StorageAccount to put DSC scripts
New-AzureRmStorageAccount -ResourceGroupName $RG2 -Name $StorageName -Type Standard_LRS -Location $Location -Verbose
Set-AzureRmCurrentStorageAccount -ResourceGroupName $RG2 -Name $StorageName -Verbose
#Download DSC script from GitHub and publish it
Invoke-WebRequest -Uri $DSCConfigPath -OutFile $TempDSCCOnfigPath
Publish-AzureRmVMDscConfiguration -ConfigurationPath $TempDSCCOnfigPath -ResourceGroupName $RG2 -StorageAccountName $StorageName -Force -Verbose
# Get the SAS token
$DSCSAS = New-AzureStorageBlobSASToken -Container 'windows-powershell-dsc' -Blob 'MyDsc.ps1.zip' -Permission r -ExpiryTime (Get-Date).AddHours(2000)
#Provide SAS token during deployment
New-AzureRmResourceGroup -Name $RG -Location westeurope -Force -Verbose
Write-Host "Please wait..." -BackgroundColor DarkCyan
New-AzureRmResourceGroupDeployment -ResourceGroupName $RG -TemplateUri 'https://raw.githubusercontent.com/SayreX86/Azure/master/Module3/main.json' -DSC-SasToken $DSCSAS -Verbose
#Check 8080 port access
Test-NetConnection -ComputerName samoeunikalnoeimyavm.westeurope.cloudapp.azure.com -Port 8080