#Trigger backup
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer -ContainerType "AzureVM" -Status "Registered"
$item = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
$job = Backup-AzureRmRecoveryServicesBackupItem -Item $item
$job

#Get AzureRM Disk
$getazuredisk = Get-AzureRmDisk -ResourceGroupName 'RG3'
#Set AzureRecoveryService Context
Get-AzureRmRecoveryServicesVault -Name 'RecoveryServicesVault' | Set-AzureRmRecoveryServicesVaultContext
#Get AzureRecovery Container
$namedContainer = Get-AzureRmRecoveryServicesBackupContainer  -ContainerType "AzureVM" -Status "Registered"
#Get AzureRecovery Item
$backupitem = Get-AzureRmRecoveryServicesBackupItem -Container $namedContainer -WorkloadType "AzureVM"
#Get AzureRecovery Point
$rp = Get-AzureRmRecoveryServicesBackupRecoveryPoint $backupitem

$restorejob = Restore-AzureRmRecoveryServicesBackupItem -RecoveryPoint $rp[0] -StorageAccountName 'backupsatraining' -StorageAccountResourceGroupName "RG3"
$restorejob

