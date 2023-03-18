# Cargamos las variables con los valores del laboratorio apropiados.
$ResourceGroupName = "AzureLabs"
$LabName = "agq - programación java - álvaro"

# Conectamos con el tenant.
Connect-AZAccount

# Seleccionamos la subscripción.
Select-AzContext "Ecosistema de aprendizaje"

$LabPublicIP = $null

$lab = Get-AzLabServicesLab -Name $LabName -ResourceGroupName $ResourceGroupName
if (-not $lab) {
    Write-Error "No he podido encontrar el laboratorio $($LabName) en el grupo de recursos $($ResourceGroupName)."
}

if ($lab.NetworkProfilePublicIPId) {
    # Si el laboratorio está usando "advance networking".
    # Tomamos la IP pública desde las propiedades de red.
    $LabPublicIP = Get-AzResource -ResourceId $lab.NetworkProfilePublicIPId | `
        Get-AzPublicIpAddress | `
        Select-Object -expand IpAddress
}
else {
    # Tomamos la primera VM del laboratorio, que suele ser la VM de plantilla.
    # Si no hay plantilla, se coge la primera VM de alumno.
    $vm = $lab | Get-AzLabServicesVM | Select-Object -First 1

    if ($vm) {
        if ($vm.ConnectionProfileSshAuthority) {
            $connectionAuthority = $vm.ConnectionProfileSshAuthority.Split(":")[0]
        }
        else {
            $connectionAuthority = $vm.ConnectionProfileRdpAuthority.Split(":")[0]
        }
        $LabPublicIP = [System.Net.DNS]::GetHostByName($connectionAuthority).AddressList.IPAddressToString | `
            Where-Object { $_ } | Select-Object -First 1
    }
}

if ($LabPublicIP) {
    Write-Output "La IP pública para el laboratorio $($lab.Name) es $LabPublicIP."
}
else {
    Write-Error "El laboratorio debe publicarse para poder obtener su IP pública."
}



