# ConfiguracionFirewallParaAzureLabs

Dado que Azure Lab Services se ejecuta en la nube pública, es posible que se necesite una configuración adicional para permitir a los estudiantes obtener acceso a su máquina virtual.

Cada laboratorio usa una sola dirección IP pública y varios puertos. 

Todas las máquinas virtuales, tanto la plantilla de máquina virtual como las máquinas virtuales de estudiantes, ***usarán esta dirección IP pública***. La dirección IP pública no cambiará durante la vida del laboratorio. 

Cada máquina virtual tendrá un ***número de puerto diferente***. 

Los intervalos de puertos para las conexiones SSH son ***4980-4989*** y ***5000-6999***. 

Los intervalos de puertos para las conexiones RDP son ***4990-4999*** y ***7000-8999***. 

Por consiguiente, es imperativo crear esas reglas en el FW del cliente para poder acceder a los labs.

Para saber la IP pública del laboratorio, abrimos una terminal de PowerShell.

Si no tenemos instalados los cmdlets para interactuar con los laboratorios, escribimos.
```
Install-Module Az.LabServices
```

A continuación conectamos con el tenant.
```
Connect-AZAccount
```

Mostramos las subscripciones a las que tenemos acceso.
```
Get-AzSubscription
```

Seleccionamos la subscripción.
```
Select-AzContext "Ecosistema de aprendizaje"
```
Cargamos las variables con los valores del laboratorio apropiados.
```
$ResourceGroupName = "AzureLabs"
```
```
$LabName = "agq - programación java - álvaro"
```

ejecutamos este script.
```
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
```


