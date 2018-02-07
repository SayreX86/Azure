Login-AzureRmAccount

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
$getazuredisk = Get-AzureRmDisk -ResourceGroupName 'RG3'
#Get AzureRecovery Container
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer  -ContainerType "AzureVM" -Status "Registered"
#Get AzureRecovery Item
$backupitem = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
#Get AzureRecovery Point
$rp = Get-AzureRmRecoveryServicesBackupRecoveryPoint $backupitem
#Restore backup
$restorejob = Restore-AzureRmRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName 'savm2training' -StorageAccountResourceGroupName "RG3"
while ((Get-AzureRmRecoveryServicesBackupJob -Operation Restore -Status InProgress) -ne $null)
{
    Write-Output "Waiting for restore..."
}




