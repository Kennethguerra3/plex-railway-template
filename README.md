# Plex Media Server - Railway Template 🎬

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/pms-docker-railway)

Servidor Plex completo en Railway con **Gestor de Archivos Web** integrado. Despliega en minutos con almacenamiento persistente.

---

## ✨ Características

- 🎬 **Plex Media Server**: Streaming de películas, series y música.
- 📂 **File Browser Integrado**: Sube tus archivos directamente desde el navegador (Puerto 9090).
- 💾 **Persistencia Total**: Volúmenes Railway para `/config`, `/data` y `/transcode`.
- 🚀 **Zero Config Proxy**: Acceso seguro mediante TCP Proxy de Railway.

---

## 🚀 Despliegue Rápido

### 1. Obtener Token de Plex

Ve a [plex.tv/claim](https://plex.tv/claim), inicia sesión y copia el código (ej: `claim-xxxx`).

### 2. Deploy en Railway

Haz clic en el botón de arriba, pega tu token en `PLEX_CLAIM` y dale a **Deploy**.

### 3. Configurar el Gestor de Archivos (VITAL)

Para subir tus películas, necesitas habilitar el acceso al puerto 9090:

1. En tu servicio de Railway, ve a la pestaña **Settings**.
2. Baja hasta **Public Networking**.
3. Haz clic en **+ TCP Proxy**.
4. Escribe el puerto: `9090`.
5. Railway te dará una dirección (ej: `shuttle.proxy.rlwy.net:12345`). **¡Esa es URL para subir archivos!**

---

## 📂 Cómo gestionar tus medios

1. **Acceso al Gestor**: Usa la dirección del TCP Proxy creada arriba.
2. **Subida**: Arrastra tus archivos a la carpeta `/data`.
3. **Plex**: Entra en Plex (`...up.railway.app`), ve a Bibliotecas y añade la carpeta `/data`.

> [!IMPORTANT]
> **Credenciales por defecto:**
>
> - **Usuario**: `admin`
> - **Contraseña**: `admin`
> *(Se recomienda cambiar la contraseña en Settings -> User Management tras el primer ingreso)*.

---

## ⚙️ Variables de Entorno

| Variable | Descripción | Requerido |
|----------|-------------|-----------|
| `PLEX_CLAIM` | Tu token de [plex.tv/claim](https://plex.tv/claim) | ✅ Sí |
| `TZ` | Zona horaria (ej: `America/Mexico_City`) | No |

---

## 🔧 Solución de Problemas

### "¿Por qué me redirige a Plex al intentar subir archivos?"

Asegúrate de estar usando la dirección del **TCP Proxy** y no el dominio principal. Prueba siempre desde una **ventana de incógnito** para evitar la cache del navegador.

### "No veo mis películas en Plex"

Asegúrate de que has subido los archivos a `/data` y que en la configuración de la Biblioteca de Plex has seleccionado exactamente esa ruta.

---

## 📄 Licencia
Basado en el contenedor oficial [plexinc/pms-docker](https://github.com/plexinc/pms-docker).
