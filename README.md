# ConfiguracionFirewallParaAzureLabs

Dado que Azure Lab Services se ejecuta en la nube pública, es posible que se necesite una configuración adicional para permitir a los estudiantes obtener acceso a su máquina virtual.

Cada laboratorio usa ***una sola*** dirección IP pública y ***varios*** puertos. 

Todas las máquinas virtuales, tanto la plantilla de máquina virtual como las máquinas virtuales de estudiantes, ***usarán esta dirección IP pública***. La dirección IP pública no cambiará durante la vida del laboratorio. 

Cada máquina virtual tendrá un ***número de puerto diferente***. 

Los intervalos de puertos para las conexiones ***SSH*** son ***4980-4989*** y ***5000-6999***. 

Los intervalos de puertos para las conexiones ***RDP*** son ***4990-4999*** y ***7000-8999***. 

Para saber la IP pública del laboratorio, usamos el portal.

![IP](./img/202303181846.png)

Para comunicar al cliente es mejor dar la ***IP*** que la DNS que genera Azure, que es de la forma ***ml-lab-b41bd8c5-fc48-48a4-8cfa-69afb4b660ff.northeurope.cloudapp.azure.com***, si se intenta escribir manualmente será un problema.

Por consiguiente, es imperativo crear esas reglas en el FW del cliente para poder acceder a los labs.
