# Plex Media Server - Railway Template

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

Servidor multimedia completo con soporte para Google Drive ilimitado. Despliega en Railway en 5 minutos.

---

## 🚀 Inicio Rápido

1. Haz clic en el botón "Deploy on Railway" arriba
2. Obtén tu `PLEX_CLAIM` desde [plex.tv/claim](https://plex.tv/claim)
3. Espera a que termine el deploy
4. Configura TCP Proxy Port `32400` en Settings → Networking
5. ¡Listo! Accede desde [app.plex.tv](https://app.plex.tv)

---

## � Configuración de Google Drive (Opcional)

### ⭐ Método Recomendado: Service Account (5 minutos)

✅ Sin instalar nada en tu PC  
✅ Solo copiar/pegar un archivo JSON  
✅ Nunca expira  

### Paso 1: Crear Proyecto en Google Cloud

1. Ve a [console.cloud.google.com](https://console.cloud.google.com)
2. Clic en "Nuevo Proyecto"
3. Nombre: `Plex Media Server`
4. Clic en "Crear"

### Paso 2: Habilitar Google Drive API

1. Menú → "APIs y servicios" → "Biblioteca"
2. Busca: `Google Drive API`
3. Clic en "Habilitar"

### Paso 3: Crear Service Account

1. Menú → "IAM y administración" → "Cuentas de servicio"
2. Clic en "+ Crear cuenta de servicio"
3. Nombre: `plex-gdrive`
4. Clic en "Crear y continuar" → "Listo"

### Paso 4: Descargar Credenciales JSON

1. Clic en el email de la Service Account
2. Pestaña "Claves" → "Agregar clave" → "Crear clave nueva"
3. Tipo: **JSON** → "Crear"
4. Copia el email de la Service Account:

```
plex-gdrive@tu-proyecto-123456.iam.gserviceaccount.com
```

### Paso 5: Compartir Carpeta de Google Drive

1. Ve a [drive.google.com](https://drive.google.com)
2. Crea carpeta: **"Plex"**
3. Dentro crea: `Movies`, `TV Shows`, `Music`
4. Clic derecho en "Plex" → "Compartir"
5. Pega el email de la Service Account
6. Cambia permiso a **"Editor"**
7. Desactiva "Notificar a las personas"
8. Clic en "Compartir"

### Paso 6: Configurar en Railway

1. Abre el archivo `.json` con Bloc de notas
2. Copia TODO el contenido (Ctrl+A, Ctrl+C)
3. En Railway → "Variables":

| Variable | Valor |
|----------|-------|
| `ENABLE_RCLONE` | `true` |
| `RCLONE_SERVICE_ACCOUNT_JSON` | *Pegar el JSON completo* |
| `RCLONE_REMOTE_PATH` | `/Plex` |

### Paso 7: Subir Películas

Organiza tus archivos:

```
Google Drive/Plex/
├── Movies/
│   ├── Avatar (2009)/
│   │   └── Avatar (2009).mkv
│   └── Inception (2010)/
│       └── Inception (2010).mp4
└── TV Shows/
    └── Breaking Bad/
        └── Season 01/
            └── Breaking Bad - S01E01.mkv
```

### Paso 8: Configurar Bibliotecas en Plex

1. Accede desde [app.plex.tv](https://app.plex.tv)
2. Clic en "+" junto a "Bibliotecas"
3. Selecciona tipo: "Películas"
4. Navega a: `/mnt/gdrive/Plex/Movies`
5. Clic en "Agregar biblioteca"

### ✅ Verificación

Revisa los logs en Railway:
```
[Rclone] Using Service Account authentication
[Rclone] ✓ Google Drive mounted successfully
[Rclone] ✓ Read access verified
```

**Guía detallada**: [SERVICE_ACCOUNT_SETUP.md](SERVICE_ACCOUNT_SETUP.md)

---

## 🔧 Configuración Post-Despliegue

### 1. Configurar TCP Proxy

1. Ve a tu servicio en Railway Dashboard
2. Pestaña **"Settings"** → **"Networking"**
3. En **"Public Networking"**, ingresa puerto: `32400`
4. Railway generará automáticamente una URL de acceso

### 2. Acceder a Plex

- **Recomendado**: [app.plex.tv](https://app.plex.tv) - Plex detectará tu servidor automáticamente
- **Alternativa**: Usa la URL del TCP Proxy que Railway generó

---

## 🐛 Troubleshooting

### El servidor no es accesible

- ✅ Verifica que configuraste TCP Proxy Port `32400`
- ✅ Revisa los logs en Railway Dashboard

### El servidor se reinicia constantemente

- ✅ Verifica que `PLEX_CLAIM` no esté expirado (válido 4 minutos)
- ✅ Revisa los logs para errores

### Google Drive: "Cannot read files"

- ✅ Verifica que compartiste la carpeta con el email de Service Account
- ✅ Asegúrate de dar permisos de "Editor"
- ✅ Revisa logs: `[Rclone] ✓ Read access verified`

### Google Drive: "Invalid JSON"

- ✅ Abre el JSON con Bloc de notas (no Word)
- ✅ Copia TODO sin modificar
- ✅ Verifica que empieza con `{` y termina con `}`

---

## 📚 Recursos

- [Documentación Oficial de Plex](https://support.plex.tv/)
- [Repositorio Original](https://github.com/plexinc/pms-docker)
- [Documentación de Railway](https://docs.railway.app/)
- [Guía Service Account Detallada](SERVICE_ACCOUNT_SETUP.md)

---

## 📄 Licencia

Este proyecto usa el contenedor oficial de Plex Media Server. Consulta la [licencia de Plex](https://www.plex.tv/about/privacy-legal/plex-terms-of-service/).
