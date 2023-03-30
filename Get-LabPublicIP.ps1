$ResourceGroupName = "AzureLabs"
$LabName = Read-Host "Introduce el nombre del laboratorio"
$LabPublicIP = $null

# Conectamos con Azure.
Connect-AzAccount

# Seleccionamos la subscripción "Ecosistema de aprendizaje"
Set-AzContext -Subscription "a08cba4d-ca3c-47d6-ad7d-aa604b242d92" 


$lab = Get-AzLabServicesLab -Name $LabName -ResourceGroupName $ResourceGroupName
if (-not $lab) {
    Write-Error "No he podido encontrarel laboratorio $($LabName) en el grupo de recursos $($ResourceGroupName)."

}

if ($lab.NetworkProfilePublicIPId) {
    # Si el laboratorio está usando el networking avanzado, obtengo su IP pública desde las propiedades de la interfaz de red.
    $LabPublicIP = Get-AzResource -ResourceId $lab.NetworkProfilePublicIPId | Get-AzPublicIpAddress | Select-Object -expand IpAddress
}
else {
    # Obtengo la IP Pública de la primera VM del laborario. 
    # Si el lab se ha personalizado, la IP pública se obtiene desde la VM de plantilla.
    # Si no se personalizó, la IP pública se toma de la primera VM publicada.
    $vm = $lab | Get-AzLabServicesVM | Select-Object -First 1

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
    Write-Output "Mensaje para el cliente:"
    Write-Output "Permitir las conexiones salientes hacia la IP $LabPublicIP para los protocolos RDP y SSH hacia los rangos de puertos siguientes:"
    Write-Output "4980-4989, 5000-6999, y 7000-8999"
}
else {
    Write-Error "El laboratorio debe publicarse para obtener la IP pública."
}