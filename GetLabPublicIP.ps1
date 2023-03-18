$LabPublicIP = $null

$lab = Get-AzLabServicesLab -Name $LabName -ResourceGroupName $ResourceGroupName
if (-not $lab) {
    Write-Error "Could find lab $($LabName) in resource group $($ResourceGroupName)."
}

if ($lab.NetworkProfilePublicIPId) {
    #Lab is using advance networking
    # Get public IP from networking properties
    $LabPublicIP = Get-AzResource -ResourceId $lab.NetworkProfilePublicIPId | Get-AzPublicIpAddress | Select-Object -expand IpAddress
}
else {
    #Get first VM from lab
    # If customizable lab, this is the template VM
    # If non-customizable lab, this is the first VM published.
    $vm = $lab | Get-AzLabServicesVM | Select -First 1

    if ($vm) {
        if ($vm.ConnectionProfileSshAuthority) {
            $connectionAuthority = $vm.ConnectionProfileSshAuthority.Split(":")[0]
        }
        else {
            $connectionAuthority = $vm.ConnectionProfileRdpAuthority.Split(":")[0]
        }
        $LabPublicIP = [System.Net.DNS]::GetHostByName($connectionAuthority).AddressList.IPAddressToString | Where-Object { $_ } | Select -First 1

    }
}

if ($LabPublicIP) {
    Write-Output "Public IP for $($lab.Name) is $LabPublicIP."
}
else {
    Write-Error "Lab must be published to get public IP address."
}