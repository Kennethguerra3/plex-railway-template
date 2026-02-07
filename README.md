# Plex Media Server - Railway Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

Servidor multimedia completo con Google Drive ilimitado. Despliega en Railway en 5 minutos.

---

# Deploy and Host

Despliega tu propio servidor Plex Media Server en Railway con un solo clic. Este template incluye configuración automática de Rclone para integración con Google Drive, permitiéndote almacenar tu biblioteca multimedia en la nube sin costos adicionales de almacenamiento en Railway.

## About Hosting

Este template despliega Plex Media Server en Railway usando el contenedor oficial de Docker. Railway proporciona infraestructura escalable con CPU y RAM dedicados para streaming fluido, networking público para acceso desde cualquier lugar, despliegue automático con actualizaciones y reinicio automático, y logs en tiempo real para monitoreo completo del servidor.

## Why Deploy

¿Por qué desplegar Plex en Railway?

- Sin hardware dedicado: No necesitas un servidor físico 24/7
- Acceso global: Tu biblioteca disponible desde cualquier dispositivo
- Almacenamiento ilimitado: Usa Google Drive para tu contenido multimedia
- Bajo costo: Plan Hobby de Railway desde $5/mes
- Configuración simple: Listo en 5 minutos sin conocimientos técnicos

## Common Use Cases

- Biblioteca personal: Organiza y accede a tu colección de películas y series
- Streaming familiar: Comparte tu biblioteca con familiares en diferentes ubicaciones
- Servidor multimedia portátil: Accede a tu contenido desde cualquier dispositivo
- Backup en la nube: Mantén tu contenido seguro en Google Drive
- Streaming de música: Biblioteca de audio personal accesible en cualquier lugar

## Dependencies for

### Deployment Dependencies

Este template requiere las siguientes dependencias que se configuran automáticamente:

- Plex Media Server: Servidor multimedia oficial (incluido en el contenedor)
- Rclone: Para montaje de Google Drive (incluido en el contenedor)
- Google Drive API: Para acceso a archivos en la nube (requiere configuración manual)

Servicios externos necesarios:

- Cuenta de Plex (gratis en plex.tv)
- Cuenta de Railway (plan Hobby: $5/mes)
- Cuenta de Google Cloud (gratis, para Service Account)
- Google Drive (gratis 15GB o Google One desde $2/mes)

---

## Despliegue Inicial

### Paso 1: Deploy en Railway

1. Haz clic en el botón "Deploy on Railway" arriba
2. Railway te pedirá configurar 1 variable obligatoria: PLEX_CLAIM
3. Obtén tu token en plex.tv/claim (expira en 4 minutos)
4. Haz clic en "Deploy" y espera 2-3 minutos


## Configurar Google Drive

### Paso 1: Crear Service Account y Obtener Credenciales JSON

**1.1. Crear Proyecto en Google Cloud**

1. Ve a [console.cloud.google.com](https://console.cloud.google.com)
2. En la parte superior, haz clic en el selector de proyectos
3. Clic en "Proyecto nuevo"
4. Nombre del proyecto: `Plex Media Server`
5. Clic en "Crear"
6. Espera unos segundos hasta que se cree el proyecto

**1.2. Habilitar Google Drive API**

1. Asegúrate de que estás en el proyecto "Plex Media Server" (verifica en la parte superior)
2. En el menú lateral (☰), ve a: "APIs y servicios" → "Biblioteca"
3. En el buscador, escribe: `Google Drive API`
4. Haz clic en "Google Drive API"
5. Clic en el botón azul "HABILITAR"
6. Espera a que se habilite (tarda unos segundos)

**1.3. Crear Service Account**

1. En el menú lateral (☰), ve a: "IAM y administración" → "Cuentas de servicio"
2. Clic en el botón "+ CREAR CUENTA DE SERVICIO" (parte superior)
3. Completa el formulario:
   - Nombre de la cuenta de servicio: `plex-gdrive`
   - ID de la cuenta de servicio: se genera automáticamente como `plex-gdrive`
   - Descripción (opcional): `Service Account para Plex Media Server`
4. Clic en "CREAR Y CONTINUAR"
5. En "Otorgar acceso a este proyecto", simplemente haz clic en "CONTINUAR" (no necesitas seleccionar ningún rol)
6. En "Otorgar acceso a usuarios", haz clic en "LISTO"

**1.4. Descargar Credenciales JSON**

1. Verás la lista de cuentas de servicio. Busca la que acabas de crear: `plex-gdrive@tu-proyecto-xxxxx.iam.gserviceaccount.com`
2. **IMPORTANTE**: Copia este email completo, lo necesitarás en el siguiente paso
3. Haz clic en el email de la Service Account para abrir sus detalles
4. Ve a la pestaña "CLAVES" (en la parte superior)
5. Clic en "AGREGAR CLAVE" → "Crear clave nueva"
6. Selecciona el tipo: "JSON"
7. Clic en "CREAR"
8. Se descargará automáticamente un archivo con nombre similar a: `plex-media-server-xxxxx-xxxxxxxxxx.json`
9. **Guarda este archivo en un lugar seguro**, lo necesitarás para configurar Railway

**Ejemplo del email de Service Account que debes copiar:**
```
plex-gdrive@plex-media-server-123456.iam.gserviceaccount.com
```

### Paso 2: Configurar Google Drive

1. En drive.google.com, crea carpeta Plex
2. Dentro de Plex, crea: Movies, TV Shows, Music
3. Comparte carpeta Plex con el email de Service Account (permiso Editor)

### Paso 3: Variables en Railway

Agrega estas variables en Railway:

| Variable | Valor |
|----------|-------|
| ENABLE_RCLONE | true |
| RCLONE_SERVICE_ACCOUNT_JSON | Contenido completo del archivo .json |
| RCLONE_REMOTE_PATH | /Plex |

### Paso 4: Organizar Archivos

Películas:

```
Plex/Movies/
├── Avatar (2009)/
│   └── Avatar (2009).mkv
└── Inception (2010)/
    └── Inception (2010).mp4
```

Series:

```
Plex/TV Shows/
└── Breaking Bad/
    └── Season 01/
        └── Breaking Bad - S01E01.mkv
```

### Paso 5: Agregar Bibliotecas en Plex

1. Abre app.plex.tv
2. Clic en + → Películas
3. Ruta: /mnt/gdrive/Plex/Movies
4. Repite para Series: /mnt/gdrive/Plex/TV Shows


## Problemas Comunes

### No puedo acceder a Plex

- Verifica que configuraste TCP Proxy Port 32400 en Settings → Networking
- Accede desde app.plex.tv, no desde la URL de Railway

### El servidor se reinicia constantemente

- Tu PLEX_CLAIM expiró (válido solo 4 minutos)
- Genera uno nuevo en plex.tv/claim
- Actualiza la variable en Railway

### Google Drive: Cannot read files

- Verifica que compartiste la carpeta Plex con el email de Service Account
- El permiso debe ser Editor, no Lector
- Revisa los logs: debe decir Read access verified

### Google Drive: Invalid JSON

- Abre el archivo .json con Bloc de notas (no Word)
- Selecciona TODO (Ctrl+A) y copia (Ctrl+C)
- Pega en Railway sin modificar nada
- El JSON debe empezar con { y terminar con }

### No veo mis películas en Plex

- Verifica que los archivos estén en /mnt/gdrive/Plex/Movies
- Usa la nomenclatura correcta: Avatar (2009)/Avatar (2009).mkv
- Espera 5-10 minutos para que Plex escanee los archivos

---

## Preguntas Frecuentes

### ¿Cuánto cuesta?

- Railway: Plan Hobby $5/mes (incluye crédito)
- Google Drive: Gratis (15GB) o Google One desde $2/mes
- Plex: Gratis (Plex Pass opcional: $5/mes)

### ¿Puedo compartir con amigos?

Sí, desde Plex:

1. Settings → Users & Sharing
2. Invite Friends
3. Ingresa su email de Plex

### ¿Funciona en móviles?

Sí, descarga la app de Plex:

- iOS: App Store
- Android: Google Play Store

### ¿Qué formatos soporta?

- Video: MP4, MKV, AVI, MOV, WMV
- Audio: MP3, AAC, FLAC, AC3, DTS
- Subtítulos: SRT, ASS, SSA, VTT

---

## Variables de Entorno

### Variables Obligatorias

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| PLEX_CLAIM | Token de autenticación (expira en 4 min) | claim-xxxxxxxxxxxx |

### Variables de Google Drive

| Variable | Descripción | Valor |
|----------|-------------|-------|
| ENABLE_RCLONE | Habilitar Google Drive | true |
| RCLONE_SERVICE_ACCOUNT_JSON | Credenciales JSON completas | {"type":"service_account",...} |
| RCLONE_REMOTE_PATH | Ruta en Google Drive | /Plex |

### Variables Opcionales

| Variable | Descripción | Valor por defecto |
|----------|-------------|-------------------|
| TZ | Zona horaria | America/New_York |
| PLEX_UID | User ID para permisos | 1000 |
| PLEX_GID | Group ID para permisos | 1000 |
| ADVERTISE_IP | IP pública para acceso remoto | Auto-detectado |
| ALLOWED_NETWORKS | Redes permitidas sin auth | 192.168.0.0/16 |

---

## Troubleshooting

### Error: Server is not powerful enough

Solución:

1. Plex Settings → Transcoder → Prefer higher speed encoding
2. Reduce Background transcoding x264 preset a Very Fast
3. En la app: Settings → Quality → Remote Streaming: Maximum

### Google Drive: Error 403 - Rate Limit Exceeded

Agrega esta variable en Railway:

```
RCLONE_DRIVE_CHUNK_SIZE=128M
```

### Google Drive: Cannot authenticate

Verificación:

1. El JSON debe empezar con { y terminar con }
2. Debe contener: "type": "service_account"
3. Email debe terminar en @tu-proyecto.iam.gserviceaccount.com
4. Carpeta compartida con permiso Editor
5. Google Drive API debe estar habilitada

---

## Mejores Prácticas

### Optimización de Archivos

Formatos recomendados:

- Video: MP4 (H.264) - Mejor compatibilidad
- Audio: AAC - Reproducción directa en todos los dispositivos
- Subtítulos: SRT - Ligeros y compatibles

Compresión:

- Usa Handbrake para comprimir
- Preset recomendado: Fast 1080p30
- Reduce bitrate a 2-4 Mbps para 1080p

### Organización de Bibliotecas

```
Google Drive/Plex/
├── Movies/
│   ├── Avatar (2009)/
│   │   ├── Avatar (2009).mkv
│   │   └── Avatar (2009).es.srt
│   └── Inception (2010)/
│       └── Inception (2010).mp4
├── TV Shows/
│   └── Breaking Bad/
│       ├── Season 01/
│       └── Season 02/
└── Music/
    └── Artist/
        └── Album/
```

### Rendimiento

- Direct Play: Evita transcodificación, usa menos CPU
- Límite de bitrate: Ajusta según tu conexión
- Calidad remota: Configura en Settings → Remote Access

---

## Recursos Adicionales

- Documentación de Plex: support.plex.tv
- Guía de Nomenclatura: support.plex.tv/articles/naming-and-organizing-your-movie-media-files
- Repositorio Original: github.com/plexinc/pms-docker
- Documentación de Railway: docs.railway.app
- Foro de Plex: forums.plex.tv

---

## Licencia

Este proyecto usa el contenedor oficial de Plex Media Server. Consulta la licencia de Plex en plex.tv/about/privacy-legal/plex-terms-of-service.
