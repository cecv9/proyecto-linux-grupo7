# Exportación e importación de la OVA

## Objetivo

Demostrar que la máquina virtual se puede exportar como `proyecto-isl135-grupo7.ova`,
verificar su integridad con SHA-256, importarla en otra copia y comprobar que los
cuatro servicios siguen funcionando.

## Qué se hizo

1. Se verificaron los reenvíos NAT `2222`, `8080`, `8081`, `8082` y `8083`.
2. Se apagó la VM y se exportó a OVA con `VBoxManage export`.
3. Se generó y verificó el SHA-256.
4. Se importó como `servidor-grupo7-copia` con MAC regenerada.
5. Se comprobó que los contenedores y los cuatro puertos responden `200`.

## Comandos principales

```bash
# En el host, con la VM apagada
VBoxManage export "Debian 13" --output "proyecto-isl135-grupo7.ova" --manifest
sha256sum proyecto-isl135-grupo7.ova | tee proyecto-isl135-grupo7.ova.sha256
sha256sum -c proyecto-isl135-grupo7.ova.sha256

# Importar como copia independiente
VBoxManage import "proyecto-isl135-grupo7.ova" --vsys 0 --vmname "servidor-grupo7-copia"
VBoxManage modifyvm "servidor-grupo7-copia" --macaddress1 auto
VBoxManage showvminfo "servidor-grupo7-copia" --machinereadable | grep -i Forwarding
```

## Evidencias de la OVA

| Imagen / archivo | Descripción |
|---|---|
| [`OVA_01_reenvios_nat.png`](OVA_01_reenvios_nat.png) | Reenvíos NAT configurados antes de exportar. |
| [`OVA_02_espacio_disco.png`](OVA_02_espacio_disco.png) | Espacio disponible en disco antes de la exportación. |
| [`OVA_03_vm_apagada.png`](OVA_03_vm_apagada.png) | VM apagada correctamente antes de exportar. |
| [`OVA_04_exportacion.png`](OVA_04_exportacion.png) | Exportación de la VM a OVA completada. |
| [`OVA_05_tamano.png`](OVA_05_tamano.png) | Tamaño del archivo OVA generado. |
| [`OVA_06_contenido.png`](OVA_06_contenido.png) | Contenido del OVA: descriptor OVF, disco VMDK y manifiesto. |
| [`OVA_07_sha256_generado.png`](OVA_07_sha256_generado.png) | Generación del checksum SHA-256. |
| [`OVA_08_sha256_verificado.png`](OVA_08_sha256_verificado.png) | Verificación del checksum SHA-256. |
| [`OVA_09_dry_run.png`](OVA_09_dry_run.png) | Simulación de importación con `--dry-run`. |
| [`OVA_10_nombre_libre.png`](OVA_10_nombre_libre.png) | Comprobación de que el nombre de la copia está libre. |
| [`OVA_11_importacion.png`](OVA_11_importacion.png) | Importación de la OVA como copia independiente. |
| [`OVA_12_copia_registrada.png`](OVA_12_copia_registrada.png) | Copia registrada en VirtualBox. |
| [`OVA_13_mac_regenerada.png`](OVA_13_mac_regenerada.png) | Dirección MAC regenerada para evitar conflictos. |
| [`OVA_14_nat_copia.png`](OVA_14_nat_copia.png) | Reenvíos NAT de la copia importada. |
| [`OVA_15_copia_arrancada.png`](OVA_15_copia_arrancada.png) | Copia encendida correctamente. |
| [`OVA_16_contenedores_copia.png`](OVA_16_contenedores_copia.png) | Contenedores activos dentro de la copia. |
| [`OVA_17_servicios_copia.png`](OVA_17_servicios_copia.png) | Servicios del proyecto funcionando en la copia. |
| [`OVA_18_http_copia.png`](OVA_18_http_copia.png) | Cuatro puertos con HTTP 200 dentro de la copia. |
| [`OVA_19_verificacion_copia.png`](OVA_19_verificacion_copia.png) | Verificación integral de la copia importada. |
| [`OVA_20_http_copia_confirmado.png`](OVA_20_http_copia_confirmado.png) | Confirmación de los cuatro puertos en la copia. |
| [`OVA_20_http_desde_host.png`](OVA_20_http_desde_host.png) | Cuatro puertos con HTTP 200 desde el host. |
| [`proyecto-isl135-grupo7.ova.sha256`](proyecto-isl135-grupo7.ova.sha256) | Checksum SHA-256 de la OVA final. |

## Resultado

La OVA final se exportó, se verificó con SHA-256 y se importó como una copia
independiente. Los cuatro servicios respondieron `HTTP 200` tanto dentro de la
copia como desde el host.
