Install-Module Az.LabServices

# Cargamos las variables con los valores del laboratorio apropiados.
$ResourceGroupName = "AzureLabs"
$LabName = "agq - programación java - álvaro"

# Conectamos con el tenant.
Connect-AZAccount

# Seleccionamos la subscripción.
Set-AzContext -Subscription "Ecosistema de aprendizaje"

# Inicia sesión en Azure PowerShell
Connect-AzAccount

# Obtiene una lista de los laboratorios disponibles
$lab = Get-AzLab -ResourceGroupName $ResourceGroupName -Name $LabName

# Obtiene una lista de las máquinas virtuales en el laboratorio seleccionado
$vm = Get-AzLabVM -Lab $lab

# Selecciona la máquina virtual de interés
$vmSeleccionado = $vm | Where-Object { $_.Name -eq "nombre_de_la_maquina_virtual" }

# Obtiene la dirección IP pública de la máquina virtual seleccionada
$ipPublica = Get-AzPublicIpAddress -Name $vmSeleccionado.Name -ResourceGroupName $lab.ResourceGroupName

# Muestra la dirección IP pública en la consola
Write-Host "La dirección IP pública de la máquina virtual $($vmSeleccionado.Name) es $($ipPublica.IpAddress)"
