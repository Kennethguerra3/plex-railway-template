# Plex Media Server - Railway Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

Servidor Plex completo en Railway. Despliega en 5 minutos con almacenamiento persistente.

---

## 🚀 Deploy and Host

Despliega tu propio servidor Plex en Railway con un solo clic. Railway proporciona hosting en la nube con volúmenes persistentes para tu biblioteca multimedia.

### About Hosting

Railway es una plataforma de hosting moderna que simplifica el despliegue de aplicaciones. Este template incluye:

- Configuración automática de Plex Media Server
- Volúmenes persistentes para configuración y medios
- Healthchecks automáticos
- Actualizaciones de Plex

### Why Deploy

**Ventajas de Plex en Railway:**

- ✅ **Deploy instantáneo** - Listo en 5 minutos
- ✅ **Almacenamiento persistente** - Tus configuraciones y bibliotecas se mantienen
- ✅ **Acceso remoto** - Streaming desde cualquier lugar
- ✅ **Actualizaciones automáticas** - Siempre la última versión de Plex

### Common Use Cases

- **Biblioteca personal**: Organiza y transmite tus películas y series
- **Servidor familiar**: Comparte contenido con familiares
- **Streaming remoto**: Accede a tu contenido desde cualquier dispositivo
- **Servidor multimedia centralizado**: Un solo lugar para todos tus medios

---

## ✨ Características

- 🎬 **Servidor Plex completo** - Streaming de películas, series, música y fotos
- 💾 **Almacenamiento persistente** - Volúmenes Railway para datos y configuración
- 🚀 **Deploy automático** - Un clic y listo
- 🔄 **Actualización automática** - Siempre la última versión de Plex
- 🌐 **Acceso remoto** - Configura con tu cuenta de Plex

---

## 📦 Dependencies

### Deployment Dependencies

Este template requiere:

- **Cuenta de Railway** (plan Hobby o superior)
- **Cuenta de Plex** (gratuita en [plex.tv](https://plex.tv))
- **Token de reclamación** (claim token) de Plex

**Volúmenes Railway:**

- `/config` - Configuración de Plex (5GB recomendado)
- `/data` - Biblioteca multimedia (según tu contenido)
- `/transcode` - Archivos temporales de transcodificación

---

## 🚀 Despliegue Rápido

### Paso 1: Obtener Token de Plex

1. Ve a [plex.tv/claim](https://plex.tv/claim)
2. Inicia sesión con tu cuenta de Plex
3. Copia el token que aparece (válido por 4 minutos)

### Paso 2: Deploy en Railway

1. Haz clic en el botón "Deploy on Railway"
2. Conecta tu cuenta de GitHub (si es necesario)
3. Pega el token de Plex en la variable `PLEX_CLAIM`
4. Haz clic en "Deploy"

### Paso 3: Configurar Volúmenes

Railway automáticamente crea los volúmenes necesarios:

- `plex-config` → `/config`
- `plex-data` → `/data`
- `plex-transcode` → `/transcode`

### Paso 4: Acceder a Plex

1. Espera 2-3 minutos a que el servidor inicie
2. Ve a [app.plex.tv](https://app.plex.tv)
3. Tu servidor debería aparecer automáticamente
4. Configura tus bibliotecas apuntando a `/data`

---

## 📁 Subir Contenido

### Opción 1: Railway CLI (Recomendado)

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Conectar al proyecto
railway link

# Subir archivos al volumen
railway volume upload plex-data ./Movies /data/Movies
```

### Opción 2: SFTP/SCP

Railway proporciona acceso SSH a tus volúmenes. Consulta la documentación de Railway para configurar SFTP.

### Estructura Recomendada

```
/data/
├── Movies/
│   ├── Avatar (2009)/
│   │   └── Avatar (2009).mkv
│   └── Inception (2010)/
│       └── Inception (2010).mkv
├── TV Shows/
│   └── Breaking Bad/
│       ├── Season 01/
│       │   ├── Breaking Bad - S01E01.mkv
│       │   └── Breaking Bad - S01E02.mkv
│       └── Season 02/
└── Music/
    └── Artist/
        └── Album/
```

---

## ⚙️ Variables de Entorno

| Variable | Descripción | Requerido | Valor por defecto |
|----------|-------------|-----------|-------------------|
| `PLEX_CLAIM` | Token de reclamación de plex.tv/claim | ✅ Sí | - |
| `TZ` | Zona horaria (ej: America/New_York) | No | `UTC` |
| `PLEX_UID` | User ID para permisos de archivos | No | `1000` |
| `PLEX_GID` | Group ID para permisos de archivos | No | `1000` |
| `ALLOWED_NETWORKS` | Redes sin autenticación (ej: 192.168.1.0/24) | No | - |

---

## 🔧 Troubleshooting

### Error: "Server is not powerful enough"

**Solución**:

1. Plex Settings → Transcoder → "Prefer higher speed encoding"
2. Reduce "Background transcoding x264 preset" a "Very Fast"
3. En la app: Settings → Quality → Remote Streaming: "Maximum"

### Error: "No se encuentra el servidor"

**Solución**:

1. Verifica que el deployment esté activo en Railway
2. Revisa los logs en Railway Dashboard
3. Regenera el token de Plex (expira en 4 minutos)

### Bibliotecas vacías

**Solución**:

1. Verifica que subiste archivos a `/data/Movies` o `/data/TV Shows`
2. En Plex, ve a Settings → Manage → Libraries → Scan Library Files
3. Revisa que la nomenclatura de archivos sea correcta

---

## 💡 Mejores Prácticas

### Optimización de Archivos

- **Formato**: MP4 con H.264 (mejor compatibilidad)
- **Resolución**: 1080p es suficiente para la mayoría
- **Bitrate**: 8-10 Mbps para 1080p, 3-5 Mbps para 720p

### Nomenclatura de Archivos

**Películas:**

```
Avatar (2009)/Avatar (2009).mkv
```

**Series:**

```
Breaking Bad/Season 01/Breaking Bad - S01E01.mkv
```

### Rendimiento

- **Direct Play**: Evita transcodificación, usa menos CPU
- **Límite de bitrate**: Ajusta según tu conexión
- **Calidad remota**: Configura en Settings → Remote Access

---

## 📚 Recursos Adicionales

- [Documentación de Plex](https://support.plex.tv/)
- [Guía de Nomenclatura](https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/)
- [Documentación de Railway](https://docs.railway.app/)
- [Foro de Plex](https://forums.plex.tv/)

### Límites de Railway

**Plan Hobby (Gratuito):**

- 5GB de almacenamiento incluido
- $0.25/GB/mes adicional
- 500 horas de ejecución/mes

**Plan Pro:**

- 100GB de almacenamiento incluido
- Ejecución ilimitada

---

## 📄 Licencia

Este proyecto usa el contenedor oficial de Plex Media Server. Ver [plexinc/pms-docker](https://github.com/plexinc/pms-docker) para más información.
