# ConfiguracionFirewallParaAzureLabs

Dado que Azure Lab Services se ejecuta en la nube pública, es posible que se necesite una configuración adicional para permitir a los estudiantes obtener acceso a su máquina virtual.

Cada laboratorio usa ***una sola*** dirección IP pública y ***varios*** puertos. 

## Si se usa una cuenta de laboratorio.

Esta es la opción actualmente usada por la cuenta de laboratorio ***fsierra***, que será migrada a la de plan de laboratorio cuando finalicen los cursos planificados.

Cada laboratorio usa una sola dirección IP pública y varios puertos. Todas las máquinas virtuales, tanto la plantilla de máquina virtual como las máquinas virtuales de estudiantes, ***usarán esta dirección IP pública***. La dirección IP pública no cambiará durante la vida del laboratorio. Cada máquina virtual tendrá un número de puerto diferente. El rango de los números de puerto es ***49152 - 65535***. 

## Si se usa un plan de laboratorio.

El plan de laboratorio es ***AvanteLabPlan***. 

Extrañamente la interfaz gráfica no dispone de la capacidad de mostrar la IP pública del laboratorio, por lo que se deberá obtener ejecutando [Este script](Get-LabPublicIP.ps1).


Todas las máquinas virtuales, tanto la plantilla de máquina virtual como las máquinas virtuales de estudiantes, ***usarán esta dirección IP pública***. La dirección IP pública no cambiará durante la vida del laboratorio. 

Cada máquina virtual tendrá un ***número de puerto diferente***. 

Los intervalos de puertos para las conexiones ***SSH*** son ***4980-4989*** y ***5000-6999***. 

Los intervalos de puertos para las conexiones ***RDP*** son ***4990-4999*** y ***7000-8999***. 


Por consiguiente, es imperativo crear esas reglas en el FW del cliente para que puedan acceder a los labs.

## Plantilla para notificar a los clientes (Versión cuenta de laboratorio)

Se puede enviar un correo con el siguiente contenido.

```
Todas las máquinas virtuales de los alumnos, usarán una única dirección IP pública. La dirección IP pública no cambiará durante la vida del laboratorio. Cada máquina virtual tendrá un número de puerto diferente. 

Reglas a habilitar en su firewall.

1) Permitir conexiones salientes para el protocolo RDP hacia la IP <Poner aquí la IP> y rango de puertos de destino 4990-4999 y 7000-8999. 

2) Permitir conexiones salientes para el protocolo SSH hacia la IP <Poner aquí la IP> y rango de puertos de destino 4980-4989 y 5000-6999.
```
