Login-AzureRmAccount

#Variables
$SAName = 'savm2training'
$RG = 'RG3'

#Set AzureRecoveryService Context
Get-AzureRmRecoveryServicesVault -Name 'RecoveryServicesVault' | Set-AzureRmRecoveryServicesVaultContext
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered"
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
#Trigger backup
Backup-AzureRmRecoveryServicesBackupItem -Item $item
while ((Get-AzureRmRecoveryServicesBackupJob -Operation Backup -Status InProgress) -ne $null)
{
    Write-Output "Waiting for backup..."
}

#Get AzureRM Disk
$getazuredisk = Get-AzureRmDisk -ResourceGroupName $RG
#Get AzureRecovery Container
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer  -ContainerType "AzureVM" -Status "Registered"
#Get AzureRecovery Item
$backupitem = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
#Get AzureRecovery Point
$rp = Get-AzureRmRecoveryServicesBackupRecoveryPoint $backupitem
#Restore backup
$restorejob = Restore-AzureRmRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName $SAName -StorageAccountResourceGroupName $RG
while ((Get-AzureRmRecoveryServicesBackupJob -Operation Restore -Status InProgress) -ne $null)
{
    Write-Output "Waiting for restore..."
}

#Get restored files properties
$GetLastRestore = Get-AzureRmRecoveryServicesBackupJob -Operation Restore 
$GetLastRestireID = ($GetLastRestore | Select-Object -First 1).JobID
$LastRestoreProperties = (Get-AzureRmRecoveryServicesBackupJobDetails -JobId $GetLastRestireID).Properties
$storageAccountName = $LastRestoreProperties["Target Storage Account Name"]
$containerName = $LastRestoreProperties["Config Blob Container Name"]
$blobName = $LastRestoreProperties["Config Blob Name"]

#Set storage context
$Keylist = Get-AzureRmStorageAccountKey -ResourceGroupName $RG -StorageAccountName $SAName
$Key = $Keylist[0].Value
$Ctx = New-AzureStorageContext -StorageAccountName $SAName -StorageAccountKey $Key

#Parsing JSON file
New-Item -Path $env:TMP -Name Restorejson -ItemType Directory -Force
Get-AzureStorageBlobContent -Container $containerName -Blob $blobName -Destination "$env:TMP\Restorejson" -Context $Ctx -Force
$obj = ((Get-Content -Path "$env:TMP\Restorejson\$blobName" -Raw -Encoding Unicode)).TrimEnd([char]0x00) | ConvertFrom-Json
#Prepare config for Disk
$storageType = 'StandardLRS'
$osDiskName = (Get-AzureRmVM -ResourceGroupName $RG -Name 'VM2').StorageProfile.OsDisk.Name
Write-Host "OS Disk name is: $osDiskName" -BackgroundColor DarkCyan
$osVhdUri = $obj.'properties.storageProfile'.osDisk.vhd.uri
$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location westeurope -CreateOption Import -SourceUri $osVhdUri
$newRG = New-AzureRmResourceGroup -Name 'RG-DISK-COPY' -Location westeurope -Force
#Create disk copy
$osDisk = New-AzureRmDisk -DiskName $osDiskName -Disk $diskConfig -ResourceGroupName $newRG.ResourceGroupName
Write-Host "The disk copy with name: $osDiskName is in resource group: $($newRG.ResourceGroupName)" -BackgroundColor DarkCyan