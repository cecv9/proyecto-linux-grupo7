# Fase 03 — Control de versiones y GitHub

## Objetivo

Versionar todo el proyecto y demostrar trabajo colaborativo.

## Qué se hizo

Se inicializó el repositorio Git en `/proyecto`, se creó el primer commit con la estructura, se configuró el remoto en GitHub (`cecv9/proyecto-linux-grupo7`) y se autenticó por SSH. Se agregó el `README.md` con la descripción e instalación. El historial tiene 29 commits y participación de los 4 integrantes mediante ramas y pull requests.

## Comandos principales

```bash
cd /proyecto
git init
git config user.name "Nombre del integrante"
git config user.email "correo@ues.edu.sv"
git add .
git commit -m "Estructura inicial del proyecto"
git remote add origin git@github.com:cecv9/proyecto-linux-grupo7.git
git push -u origin main
git log --oneline --graph
git shortlog -sne
```

## Evidencias de la fase

| Imagen / archivo | Descripción |
|---|---|
| [`F03_00a_vm_no_iniciada.png`](F03_00a_vm_no_iniciada.png) | VM apagada antes de iniciar la práctica. |
| [`F03_00b_vm_encendida_grafica.png`](F03_00b_vm_encendida_grafica.png) | VM encendida en modo gráfico. |
| [`F03_00c01_hostname_ssh.png`](F03_00c01_hostname_ssh.png) | Hostname y acceso SSH. |
| [`F03_00c02_usuario_adminsys.png`](F03_00c02_usuario_adminsys.png) | Usuario adminsys. |
| [`F03_00d_prevalidacion_proyecto.png`](F03_00d_prevalidacion_proyecto.png) | Prevalidación del proyecto. |
| [`F03_01_git_local.png`](F03_01_git_local.png) | Repositorio Git local inicializado en /proyecto. |
| [`F03_01a_repositorio_inicializado.png`](F03_01a_repositorio_inicializado.png) | Repositorio inicializado. |
| [`F03_01b_identidad_git.png`](F03_01b_identidad_git.png) | Identidad de Git configurada. |
| [`F03_01c_gitignore_testigos.png`](F03_01c_gitignore_testigos.png) | Creación de .gitignore y archivos testigo. |
| [`F03_01d_lista_archivos.png`](F03_01d_lista_archivos.png) | Lista de archivos del proyecto. |
| [`F03_01e_archivos_preparados.png`](F03_01e_archivos_preparados.png) | Archivos preparados. |
| [`F03_01f_primer_commit.png`](F03_01f_primer_commit.png) | Primer commit. |
| [`F03_02_remoto_push.png`](F03_02_remoto_push.png) | Repositorio remoto en GitHub y primer push. |
| [`F03_02a_repositorio_creado.png`](F03_02a_repositorio_creado.png) | Repositorio creado. |
| [`F03_02b01_ssh_sin_clave.png`](F03_02b01_ssh_sin_clave.png) | Prueba de SSH antes de registrar la clave. |
| [`F03_02b01b_clave_generada.png`](F03_02b01b_clave_generada.png) | Clave SSH generada. |
| [`F03_02b02_clave_publica.png`](F03_02b02_clave_publica.png) | Clave pública SSH. |
| [`F03_02b03_clave_en_github.png`](F03_02b03_clave_en_github.png) | Clave SSH registrada en GitHub. |
| [`F03_02b_ssh_github.png`](F03_02b_ssh_github.png) | Autenticación SSH con GitHub. |
| [`F03_03_github.png`](F03_03_github.png) | Vista del repositorio en GitHub. |
| [`F03_03a_readme.png`](F03_03a_readme.png) | README del proyecto. |
| [`F03_03a_readme_error_nueva_linea.png`](F03_03a_readme_error_nueva_linea.png) | Error de línea nueva en el README. |
| [`F03_03b01_readme_corregido.png`](F03_03b01_readme_corregido.png) | README corregido. |
| [`F03_03b02_blanco_final.png`](F03_03b02_blanco_final.png) | Comprobación del salto de línea final. |
| [`F03_03b_readme_commit.png`](F03_03b_readme_commit.png) | Commit del README. |
| [`F03_04_commits_integrantes.png`](F03_04_commits_integrantes.png) | Historial con commits de los cuatro integrantes. |
| [`F03_04a_daniel_rama.png`](F03_04a_daniel_rama.png) | Rama de trabajo de Daniel. |
| [`F03_04a_sincronizacion_equipo.png`](F03_04a_sincronizacion_equipo.png) | Sincronización del equipo. |
| [`F03_04b_readme_error_formato.png`](F03_04b_readme_error_formato.png) | Error de formato en el README. |
| [`F03_04c_readme_daniel_commit.png`](F03_04c_readme_daniel_commit.png) | Commit de Daniel al README. |
| [`F03_04d_capturas_en_vm.png`](F03_04d_capturas_en_vm.png) | Capturas dentro de la VM. |
| [`F03_04e_commit_evidencias.png`](F03_04e_commit_evidencias.png) | Commit de evidencias. |
| [`F03_04f_push_evidencias.png`](F03_04f_push_evidencias.png) | Push de evidencias. |
| [`F03_04g_commit_final_evidencias.png`](F03_04g_commit_final_evidencias.png) | Commit final de evidencias. |
| [`F03_04h_cierre_evidencias.png`](F03_04h_cierre_evidencias.png) | Cierre de evidencias de la fase 3. |
| [`F03_05_snapshot.png`](F03_05_snapshot.png) | Snapshot de cierre de la fase 3. |

## Resultado

El proyecto es trazable, reproducible y colaborativo desde GitHub.
