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

Anotamos el ***id*** y el ***TenantId*** de la subscripción deseada y lo almacenamos en variables.
```
$SubscriptionId = "<Poner el ***Id*** obtenido>"
```
```
$SubscriptionTenantId = "<Poner el ***TenantId*** obtenido>"
```




ejecutamos [este script](GetLabPublicIP.ps1)


