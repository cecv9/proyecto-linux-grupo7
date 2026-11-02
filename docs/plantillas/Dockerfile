# Imagen personalizada del proyecto ISL135 - Grupo 7
FROM nginx:latest

LABEL maintainer="Grupo 7 - ISL135"
LABEL description="Servidor web personalizado del proyecto final"

# Copia el contenido del sitio dentro de la imagen
COPY web/ /usr/share/nginx/html/

# Documenta el puerto que expone Nginx
EXPOSE 80

# Comando de inicio de Nginx en primer plano
CMD ["nginx", "-g", "daemon off;"]
