# Fase 08 — Pruebas y verificación final

## Objetivo

Demostrar que todos los servicios, la automatización y el repositorio funcionan juntos.

## Qué se hizo

Se ejecutó un contenedor Alpine en `red-proyecto` para hacer ping a `nginx-red` por nombre, se comprobaron los 4 puertos con `curl`, se revisaron cron y el log, y se ejecutó `verificar_proyecto.sh`, que valida hostname, usuarios, grupos, permisos, script, cron, Docker, contenedores, red, volumen y Git. También se reinició la VM y se confirmó que los servicios vuelven a arrancar.

## Comandos principales

```bash
docker run --rm --network red-proyecto alpine ping -c 2 nginx-red
for p in 8080 8081 8082 8083; do
  curl -s -o /dev/null -w "$p -> %{http_code}\n" http://localhost:$p
done
/proyecto/scripts/verificar_proyecto.sh; echo "Código de salida: $?"
git -C /proyecto status -sb
sudo reboot
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F08_01_alpine_ping.png`](F08_01_alpine_ping.png) | Ping desde Alpine a nginx-red usando la red personalizada. |
| [`F08_02_servicios_http.png`](F08_02_servicios_http.png) | Los cuatro puertos responden HTTP 200. |
| [`F08_02a_docker_ps.png`](F08_02a_docker_ps.png) | Contenedores activos con docker ps. |
| [`F08_03_cron_log.png`](F08_03_cron_log.png) | Cron activo y log actualizado. |
| [`F08_04_git_status_log.png`](F08_04_git_status_log.png) | Git status limpio y log de commits. |
| [`F08_04a_git_status.png`](F08_04a_git_status.png) | Estado del repositorio Git. |
| [`F08_05_verificador_listo.png`](F08_05_verificador_listo.png) | Verificador integral listo. |
| [`F08_05a_prevalidacion_script.png`](F08_05a_prevalidacion_script.png) | Prevalidación del script verificador. |
| [`F08_05b_transferencia_verificador.png`](F08_05b_transferencia_verificador.png) | Transferencia del verificador a la VM. |
| [`F08_05c_instalacion_script.png`](F08_05c_instalacion_script.png) | Instalación del script verificador. |
| [`F08_05d_permiso_verificador.png`](F08_05d_permiso_verificador.png) | Permiso de ejecución del verificador. |
| [`F08_05e_carpeta_capturas.png`](F08_05e_carpeta_capturas.png) | Carpeta de capturas en la VM. |
| [`F08_06_verificacion_integral.txt`](F08_06_verificacion_integral.txt) | Verificación integral del proyecto. |
| [`F08_06_verificacion_integral_fallo_git.png`](F08_06_verificacion_integral_fallo_git.png) | Verificación integral con fallo de Git. |
| [`F08_06a_transferencia_capturas.png`](F08_06a_transferencia_capturas.png) | Transferencia de capturas a la VM. |
| [`F08_06b_evidencias_en_vm.png`](F08_06b_evidencias_en_vm.png) | Evidencias dentro de la VM. |
| [`F08_06c_cambios_pendientes.png`](F08_06c_cambios_pendientes.png) | Cambios pendientes en Git. |
| [`F08_06d_git_add.png`](F08_06d_git_add.png) | Preparación de cambios con git add. |
| [`F08_06e_cambios_preparados.png`](F08_06e_cambios_preparados.png) | Cambios preparados para commit. |
| [`F08_07_verificacion_integral.png`](F08_07_verificacion_integral.png) | Verificación integral aprobada. |
| [`F08_07_verificacion_integral.txt`](F08_07_verificacion_integral.txt) | Verificación integral del proyecto. |
| [`F08_07a_commit_evidencias.png`](F08_07a_commit_evidencias.png) | Commit de evidencias. |
| [`F08_07b_log_copiado.png`](F08_07b_log_copiado.png) | Log copiado como evidencia. |
| [`F08_07c_transferencia_final.png`](F08_07c_transferencia_final.png) | Transferencia final de evidencias. |
| [`F08_07d_git_nuevos.png`](F08_07d_git_nuevos.png) | Archivos nuevos detectados por Git. |
| [`F08_07e_transferencia_ultimas.png`](F08_07e_transferencia_ultimas.png) | Transferencia de las últimas capturas. |
| [`F08_07f_git_add_final.png`](F08_07f_git_add_final.png) | Git add final. |
| [`F08_07g_cambios_finales_preparados.png`](F08_07g_cambios_finales_preparados.png) | Cambios finales preparados. |
| [`F08_07h_commit_verificacion_aprobada.png`](F08_07h_commit_verificacion_aprobada.png) | Commit de verificación aprobada. |
| [`F08_08_push.png`](F08_08_push.png) | Push a GitHub. |
| [`F08_08a_git_limpio.png`](F08_08a_git_limpio.png) | Repositorio limpio. |
| [`F08_09_contenedores_tras_reinicio.png`](F08_09_contenedores_tras_reinicio.png) | Los contenedores vuelven a arrancar después del reinicio. |
| [`F08_09a_reinicio.png`](F08_09a_reinicio.png) | Reinicio de la VM. |
| [`F08_09b_reconexion.png`](F08_09b_reconexion.png) | Reconexión SSH después del reinicio. |
| [`F08_09c_cd_proyecto.png`](F08_09c_cd_proyecto.png) | Cambio al directorio /proyecto. |
| [`F08_09d_servicios_tras_reinicio.png`](F08_09d_servicios_tras_reinicio.png) | Servicios después del reinicio. |
| [`F08_09e_http_tras_reinicio.png`](F08_09e_http_tras_reinicio.png) | Respuesta HTTP después del reinicio. |
| [`F08_10_post_reinicio.txt`](F08_10_post_reinicio.txt) | Verificación posterior al reinicio. |
| [`F08_10_verificacion_post_reinicio.png`](F08_10_verificacion_post_reinicio.png) | Verificación integral posterior al reinicio. |
| [`F08_10a_log_post_reinicio_copiado.png`](F08_10a_log_post_reinicio_copiado.png) | Log posterior al reinicio. |
| [`F08_10b_transferencia_final.png`](F08_10b_transferencia_final.png) | Transferencia final de evidencias. |
| [`F08_10c_revision_reinicio.png`](F08_10c_revision_reinicio.png) | Revisión después del reinicio. |
| [`F08_10d_git_add_reinicio.png`](F08_10d_git_add_reinicio.png) | Preparación de evidencias del reinicio con git add. |
| [`F08_10e_cambios_reinicio_preparados.png`](F08_10e_cambios_reinicio_preparados.png) | Cambios del reinicio preparados. |
| [`F08_10f_commit_reinicio.png`](F08_10f_commit_reinicio.png) | Commit de las evidencias del reinicio. |
| [`F08_10g_push_final.png`](F08_10g_push_final.png) | Push final. |
| [`F08_10h_git_limpio_final.png`](F08_10h_git_limpio_final.png) | Repositorio limpio al final. |
| [`F08_11_snapshot_08_final.png`](F08_11_snapshot_08_final.png) | Snapshot 08-final creado. |
| [`F08_11a_snapshot_verificado.png`](F08_11a_snapshot_verificado.png) | Snapshot 08-final verificado. |
| [`F08_11a_snapshots_prefinal.png`](F08_11a_snapshots_prefinal.png) | Listado de snapshots antes del cierre. |

## Resultado

El proyecto queda verificado de extremo a extremo y resiste un reinicio de la máquina virtual.
