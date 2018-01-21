#Connect to AzureRM Account
Login-AzureRmAccount

#region Create VNET1
#Create Resource Group
$RG1 = New-AzureRmResourceGroup -Name TestRG1 -Location westeurope 
#Add a subnet to the new VNET
$GWSubnet1 = New-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -AddressPrefix 10.12.255.0/27
#Create a new VNET
New-AzureRmVirtualNetwork -ResourceGroupName $RG1.ResourceGroupName -Name TestVNET1 -AddressPrefix 10.12.0.0/16 -Subnet $GWSubnet1 -Location westeurope
$vnet1 = Get-AzureRmVirtualNetwork -ResourceGroupName $RG1.ResourceGroupName -Name TestVNET1
$subnet1 = Get-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnet1.Name -VirtualNetwork $vnet1
#Request a public IP address to be allocated to the vnet1
$pip1 = New-AzureRmPublicIpAddress -Name TestPIP1 -ResourceGroupName $RG1.ResourceGroupName -Location westeurope -AllocationMethod Dynamic
#Create gateway configuration
$ipconfig1 = New-AzureRmVirtualNetworkGatewayIpConfig -Name GWIPConfig1 -Subnet $subnet1 -PublicIpAddress $pip1
#Create the gateway for vnet1
New-AzureRmVirtualNetworkGateway -Name TestGateway1 -ResourceGroupName $RG1.ResourceGroupName -Location westeurope `
                                 -IpConfigurations $ipconfig1 -GatewayType VPN -VpnType RouteBased -EnableBgp $false -GatewaySku Standard
#endregion Create VNET1

#region Create VNET2
$RG2 = New-AzureRmResourceGroup -Name TestRG2 -Location westeurope
$GWSubnet2 = New-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -AddressPrefix 10.42.255.0/27
New-AzureRmVirtualNetwork -ResourceGroupName $RG2.ResourceGroupName -Name TestVNET2 -AddressPrefix 10.42.0.0/16 -Subnet $GWSubnet2 -Location westeurope
$vnet2 = Get-AzureRmVirtualNetwork -ResourceGroupName $RG2.ResourceGroupName -Name TestVNET2
$subnet2 = Get-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnet2.Name -VirtualNetwork $vnet2
$pip2 = New-AzureRmPublicIpAddress -Name TestPIP2 -ResourceGroupName $RG2.ResourceGroupName -Location westeurope -AllocationMethod Dynamic
$ipconfig2 = New-AzureRmVirtualNetworkGatewayIpConfig -Name GWIPConfig2 -Subnet $subnet2 -PublicIpAddress $pip2
New-AzureRmVirtualNetworkGateway -Name TestGateway2 -ResourceGroupName $RG2.ResourceGroupName -Location westeurope `
                                 -IpConfigurations $ipconfig2 -GatewayType VPN -VpnType RouteBased -EnableBgp $false -GatewaySku Standard
#endregion Create VNET2

#Set variables to vnets 1 and 2
$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name TestGateway1 -ResourceGroupName $RG1.ResourceGroupName
$vnet2gw = Get-AzureRmVirtualNetworkGateway -Name TestGateway2 -ResourceGroupName $RG2.ResourceGroupName

#Create connection from vnet1 to vnet2
New-AzureRmVirtualNetworkGatewayConnection -Name vnet1tovnet2 -ResourceGroupName $RG1.ResourceGroupName `
-VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet2gw -Location westeurope `
-ConnectionType Vnet2Vnet -SharedKey 'Password'

#Create connection from vnet2 to vnet1
New-AzureRmVirtualNetworkGatewayConnection -Name vnet2tovnet1 -ResourceGroupName $RG2.ResourceGroupName `
-VirtualNetworkGateway1 $vnet2gw -VirtualNetworkGateway2 $vnet1gw -Location westeurope `
-ConnectionType Vnet2Vnet -SharedKey 'Password'

#Test Connections
do {
    $con1 = Get-AzureRmVirtualNetworkGatewayConnection -Name vnet1tovnet2 -ResourceGroupName $RG1.ResourceGroupName
    $con2 = Get-AzureRmVirtualNetworkGatewayConnection -Name vnet2tovnet1 -ResourceGroupName $RG2.ResourceGroupName
    $test = ($($con1.ConnectionStatus) -eq 'Connected' -and ($($con2.ConnectionStatus) -eq 'Connected'))
    Write-Host "Connection status for vnet1-to-vnet2 is: $($con1.ConnectionStatus)" -ForegroundColor Cyan
    Write-Host "Connection status for vnet2-to-vnet1 is: $($con2.ConnectionStatus)" -ForegroundColor Cyan
    $con1 = $null
    $con2 = $null
    Start-Sleep -Seconds 5
}
until ($test -eq $true)
