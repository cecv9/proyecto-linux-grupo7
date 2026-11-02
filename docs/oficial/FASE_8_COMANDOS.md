# Fase 8 — Verificación final, reinicio y OVA

> Estado: **completada el 30/10/2026** para el Grupo 7. Este documento conserva
> los comandos y resultados que cerraron la fase. No debe repetirse la
> configuración de las fases 0 a 7.

## 1. Reglas de seguridad

- Solo el usuario enciende, apaga, reinicia o modifica el estado de la VM.
- Los comandos dentro de Debian se ejecutan por SSH como `adminsys`.
- Cada comando se verifica antes de proponer el siguiente.
- Las contraseñas, tokens y claves privadas no se guardan en este documento.
- Desde `adminsys@servidor-grupo7:~$` se trabaja siempre hacia:

```bash
cd /proyecto
```

## 2. Prueba DNS y conectividad con Alpine

```bash
docker run --rm -it --network red-proyecto alpine ping -c 4 nginx-red
```

Resultado real:

- `nginx-red` se resolvió como `172.18.0.2`.
- Se recibieron 4 de 4 paquetes.
- Pérdida: `0% packet loss`.
- Evidencia: `evidencias/F08/F08_01_alpine_ping.png`.

## 3. Verificación antes del reinicio

```bash
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'
```

```bash
for p in 8080 8081 8082 8083; do
  printf '%s -> ' "$p"
  curl -s -o /dev/null -w '%{http_code}\n' "http://localhost:$p"
done
```

Resultado real: cuatro contenedores activos y cuatro respuestas `200`.

```bash
sudo tail -n 25 /var/log/proyecto/reporte_sistema.log
git status --short --branch
git log --oneline --decorate -8
```

El log mostró ejecuciones separadas 30 minutos y Git estaba en
`## main...origin/main`.

## 4. Instalar el verificador

Desde el host:

```bash
scp -P 2222 /home/enoc/Documentos/ChatGPT/ProyectoFinal_SoftwareLibre/revision-proyecto-isl135/plantillas/verificar_proyecto.sh adminsys@127.0.0.1:/tmp/
```

Dentro de la VM:

```bash
mv /tmp/verificar_proyecto.sh /proyecto/scripts/
chmod 755 /proyecto/scripts/verificar_proyecto.sh
ls -l /proyecto/scripts/verificar_proyecto.sh
```

Permisos reales: `-rwxr-xr-x adminsys adminsys`.

## 5. Ejecutar la verificación integral

La primera ejecución detectó únicamente los archivos F08 aún no versionados:

```bash
/proyecto/scripts/verificar_proyecto.sh 2>&1 | tee /proyecto/capturas/F08/F08_06_verificacion_integral.txt
```

Ese hallazgo se conservó como
`F08_06_verificacion_integral_fallo_git.png`. Después se versionaron el script y
las evidencias. Para que el propio archivo de log no ensuciara la comprobación,
la repetición se guardó fuera del repositorio y pasó:

```bash
/proyecto/scripts/verificar_proyecto.sh 2>&1 | tee /tmp/F08_07_verificacion_integral.txt
```

Resultado:

```text
RESULTADO: todas las verificaciones pasaron.
```

## 6. Commits F08

```bash
git add scripts/verificar_proyecto.sh capturas/F08
git commit -m "Fase 8: verificador integral y evidencias iniciales"
```

Commit real: `209975a`.

```bash
cp /tmp/F08_07_verificacion_integral.txt /proyecto/capturas/F08/
git add capturas/F08
git commit -m "Fase 8: evidencia de verificación integral aprobada"
```

Commit real: `9956733`.

Después del reinicio se añadieron las pruebas F08 y se creó:

```bash
git add capturas/F08
git commit -m "Fase 8: pruebas posteriores al reinicio"
git push origin main
```

Commit final real: `4f64f47`.

## 7. Prueba de reinicio

El usuario ejecuta, desde la VM:

```bash
sudo reboot
```

Tras esperar y reconectar:

```bash
ssh -p 2222 adminsys@127.0.0.1
cd /proyecto
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
systemctl is-active docker cron
```

Resultado real:

- Docker y cron: `active`.
- Los cuatro contenedores volvieron con política `unless-stopped`.
- Los puertos `8080` a `8083` respondieron `200`.
- El verificador integral posterior al reinicio volvió a pasar.

Evidencias principales:

- `F08_09_contenedores_tras_reinicio.png`
- `F08_09d_servicios_tras_reinicio.png`
- `F08_09e_http_tras_reinicio.png`
- `F08_10_verificacion_post_reinicio.png`

## 8. Snapshot final

Desde el host:

```bash
VBoxManage snapshot "Debian 13" take "08-final" --description "Fase 8 completada; commit 4f64f47; pruebas y reinicio verificados"
VBoxManage snapshot "Debian 13" list
```

Resultado real:

```text
Name: 08-final (UUID: 485510e8-b5a1-4989-a9ed-4f43a26978cc)
```

## 9. Exportar la OVA

Con la VM apagada y sin otras VMs encendidas:

```bash
VBoxManage list runningvms
VBoxManage showvminfo "Debian 13" --machinereadable | grep -i Forwarding
df -h /home/enoc/Descargas
```

El usuario apaga la VM desde dentro:

```bash
sudo poweroff
```

Desde el host:

```bash
VBoxManage export "Debian 13" --output "/home/enoc/Descargas/proyecto-isl135-grupo7.ova" --manifest
```

Resultado real: `Successfully exported 1 machine(s)`.

Verificaciones:

```bash
ls -lh /home/enoc/Descargas/proyecto-isl135-grupo7.ova*
tar -tf /home/enoc/Descargas/proyecto-isl135-grupo7.ova
sha256sum /home/enoc/Descargas/proyecto-isl135-grupo7.ova | tee /home/enoc/Descargas/proyecto-isl135-grupo7.ova.sha256
sha256sum -c /home/enoc/Descargas/proyecto-isl135-grupo7.ova.sha256
```

Datos reales:

- Tamaño aproximado: `4.2 GB`.
- Contenido: `.ovf`, `.nvram`, `.vmdk` y `.mf`.
- SHA-256:
  `249cae68a705ce772a249dd6d78aa3eaa86219b67b4409216c0928798067dcd4`.
- Resultado: `La suma coincide`.

No se sube la OVA a GitHub.

## 10. Simular e importar la OVA

Simulación sin cambios:

```bash
VBoxManage import /home/enoc/Descargas/proyecto-isl135-grupo7.ova --dry-run
```

Importación real sin reemplazar la VM original:

```bash
VBoxManage import /home/enoc/Descargas/proyecto-isl135-grupo7.ova --vsys 0 --vmname "servidor-grupo7-copia"
VBoxManage modifyvm "servidor-grupo7-copia" --macaddress1 auto
VBoxManage showvminfo "servidor-grupo7-copia" --machinereadable | grep -i Forwarding
```

La copia conservó los cinco reenvíos NAT. Con la VM original apagada:

```bash
VBoxManage startvm "servidor-grupo7-copia" --type headless
ssh -p 2222 adminsys@127.0.0.1
```

Dentro de la copia:

```bash
cd /proyecto
docker ps
systemctl is-active docker cron
/proyecto/scripts/verificar_proyecto.sh
```

Resultado real: todas las verificaciones pasaron, los cuatro puertos
respondieron `200` y una prueba adicional desde el host también devolvió `200`.

Evidencias principales en `evidencias/OVA/`:

- `OVA_04_exportacion.png`
- `OVA_08_sha256_verificado.png`
- `OVA_11_importacion.png`
- `OVA_14_nat_copia.png`
- `OVA_18_http_copia.png`
- `OVA_19_verificacion_copia.png`
- `OVA_20_http_desde_host.png`

## 11. Criterio de cierre

La Fase 8 y la OVA se consideran cerradas porque:

- Alpine alcanza `nginx-red` sin pérdida de paquetes.
- Los cuatro servicios responden `200`.
- El verificador integral pasa antes y después del reinicio.
- Los contenedores vuelven solos tras reiniciar.
- El snapshot `08-final` existe y está verificado.
- La OVA está apagada, exportada, íntegra y con checksum válido.
- Una importación independiente conserva servicios, red, volumen y puertos.

Pendiente fuera de esta fase: informe PDF, presentación y la prueba opcional o
exigida en una computadora física distinta.
