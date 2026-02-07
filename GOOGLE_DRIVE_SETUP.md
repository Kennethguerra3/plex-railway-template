# 🎬 Configuración de Google Drive para Plex

Esta guía te muestra cómo configurar Google Drive como almacenamiento de películas para tu servidor Plex en Railway usando Rclone.

---

## 📋 Requisitos Previos

1. **Cuenta de Google** con Google Drive
2. **Rclone instalado localmente** en tu PC (para configuración inicial)
3. **Plex desplegado en Railway** con esta template

---

## 🚀 Paso 1: Instalar Rclone en tu PC

### Windows
```powershell
# Usando Chocolatey
choco install rclone

# O descarga manual desde:
# https://rclone.org/downloads/
```

### Linux/Mac
```bash
# Linux
curl https://rclone.org/install.sh | sudo bash

# Mac (con Homebrew)
brew install rclone
```

---

## 🔧 Paso 2: Configurar Rclone con Google Drive

### 2.1 Iniciar Configuración
```bash
rclone config
```

### 2.2 Crear Nuevo Remote
```
n) New remote
name> gdrive
```

### 2.3 Seleccionar Google Drive
```
Storage> drive
# O busca el número correspondiente a "Google Drive"
```

### 2.4 Configurar OAuth
```
client_id> [Presiona Enter para usar el predeterminado]
client_secret> [Presiona Enter para usar el predeterminado]
scope> 1
# 1 = Full access (necesario para Plex)

root_folder_id> [Presiona Enter]
service_account_file> [Presiona Enter]
```

### 2.5 Autenticación
```
Use auto config?
y) Yes
```

Se abrirá tu navegador. Inicia sesión con tu cuenta de Google y autoriza Rclone.

### 2.6 Configuración de Team Drive
```
Configure this as a Shared Drive (Team Drive)?
n) No
# A menos que uses Google Workspace con Shared Drives
```

### 2.7 Confirmar
```
y) Yes this is OK
q) Quit config
```

---

## 📁 Paso 3: Organizar tus Películas en Google Drive

### Estructura Recomendada

Crea esta estructura en Google Drive (web o app de escritorio):

```
Google Drive/
└── Plex/
    ├── Movies/
    │   ├── Avatar (2009)/
    │   │   └── Avatar (2009).mkv
    │   ├── Inception (2010)/
    │   │   └── Inception (2010).mp4
    │   └── The Matrix (1999)/
    │       └── The Matrix (1999).mkv
    ├── TV Shows/
    │   ├── Breaking Bad/
    │   │   ├── Season 01/
    │   │   │   ├── Breaking Bad - S01E01.mkv
    │   │   │   └── Breaking Bad - S01E02.mkv
    │   │   └── Season 02/
    │   └── Game of Thrones/
    └── Music/
        └── Artist/
            └── Album/
```

### Convenciones de Nombres (Importante para Plex)

**Películas:**
```
Nombre de la Película (Año)/
  └── Nombre de la Película (Año).extensión
```

**Series:**
```
Nombre de la Serie/
  └── Season XX/
      └── Nombre - SXXeYY.extensión
```

---

## 🔑 Paso 4: Obtener la Configuración de Rclone

### 4.1 Ubicar el Archivo de Configuración
```bash
rclone config file
```

Esto mostrará la ubicación del archivo, por ejemplo:
- **Windows**: `C:\Users\TuUsuario\.config\rclone\rclone.conf`
- **Linux/Mac**: `~/.config/rclone/rclone.conf`

### 4.2 Convertir a Base64

**Linux/Mac:**
```bash
base64 -w 0 ~/.config/rclone/rclone.conf
```

**Windows (PowerShell):**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:APPDATA\rclone\rclone.conf"))
```

**Windows (CMD):**
```cmd
certutil -encode "%APPDATA%\rclone\rclone.conf" rclone-base64.txt
# Luego abre rclone-base64.txt y copia el contenido (sin las líneas BEGIN/END)
```

### 4.3 Copiar el Resultado
Copia todo el texto generado (será una cadena larga sin espacios).

---

## ⚙️ Paso 5: Configurar en Railway

### 5.1 Ir a Variables de Entorno
1. Abre tu proyecto en Railway Dashboard
2. Ve a tu servicio de Plex
3. Click en **Variables**

### 5.2 Agregar Variables

#### Variable 1: RCLONE_CONFIG
- **Nombre**: `RCLONE_CONFIG`
- **Valor**: Pega el texto base64 que copiaste en el Paso 4.3

#### Variable 2: RCLONE_REMOTE_NAME
- **Nombre**: `RCLONE_REMOTE_NAME`
- **Valor**: `gdrive` (o el nombre que usaste en el Paso 2.2)

#### Variable 3: RCLONE_REMOTE_PATH
- **Nombre**: `RCLONE_REMOTE_PATH`
- **Valor**: `/Plex` (o la ruta donde pusiste tus películas)

#### Variable 4: ENABLE_RCLONE
- **Nombre**: `ENABLE_RCLONE`
- **Valor**: `true`

### 5.3 Guardar y Redesplegar
Railway redesplegará automáticamente el servicio.

---

## 📺 Paso 6: Configurar Bibliotecas en Plex

### 6.1 Acceder a Plex
Abre tu servidor Plex:
```
https://<tu-servicio>.up.railway.app:32400/web
```

### 6.2 Agregar Biblioteca de Películas
1. Click en **+** junto a "BIBLIOTECAS"
2. Selecciona **Películas**
3. Click en **AGREGAR CARPETAS**
4. Navega a: `/mnt/gdrive/Plex/Movies`
5. Click en **AGREGAR**
6. Configura opciones (idioma, agente, etc.)
7. Click en **AGREGAR BIBLIOTECA**

### 6.3 Agregar Biblioteca de Series
Repite el proceso pero:
- Selecciona **Series**
- Ruta: `/mnt/gdrive/Plex/TV Shows`

### 6.4 Escanear Bibliotecas
Plex escaneará automáticamente. Esto puede tardar dependiendo de cuántos archivos tengas.

---

## 🔍 Verificación

### Verificar Montaje
Puedes verificar que Google Drive está montado correctamente:

1. Ve a Railway Dashboard → Tu servicio → **Logs**
2. Busca líneas como:
   ```
   [Rclone] ✓ Google Drive mounted successfully at /mnt/gdrive
   ```

### Verificar Archivos
En los logs también puedes ejecutar:
```bash
railway run ls -la /mnt/gdrive
```

Deberías ver tus carpetas de Google Drive.

---

## ⚡ Optimizaciones

### Configuración de Caché
El script de montaje ya incluye optimizaciones:
- **Caché VFS**: 10GB de caché local para archivos recientes
- **Chunk size**: 128MB para streaming eficiente
- **Buffer**: 256MB para reducir buffering

### Límites de Google Drive API
- **Cuota diaria**: 10,000 requests/día
- **Límite de descarga**: 750 GB/día

Para uso personal, estos límites son más que suficientes.

---

## 🐛 Troubleshooting

### Problema: "RCLONE_CONFIG is not set"
**Solución**: Verifica que agregaste la variable `RCLONE_CONFIG` en Railway y que contiene el base64 correcto.

### Problema: "Failed to mount Google Drive"
**Solución**: 
1. Verifica los logs en Railway
2. Revisa que el nombre del remote (`RCLONE_REMOTE_NAME`) coincida con el configurado
3. Verifica que la ruta (`RCLONE_REMOTE_PATH`) exista en Google Drive

### Problema: Plex no encuentra las películas
**Solución**:
1. Verifica que Google Drive esté montado: busca en logs `✓ Google Drive mounted successfully`
2. Verifica la estructura de carpetas en Google Drive
3. Asegúrate de usar `/mnt/gdrive/...` como ruta en Plex

### Problema: Buffering constante al reproducir
**Solución**:
1. Verifica tu conexión a internet
2. Considera reducir la calidad de streaming en Plex
3. Revisa que no hayas alcanzado los límites de Google Drive API

### Problema: "Token expired"
**Solución**:
1. Reconfigura Rclone localmente: `rclone config reconnect gdrive:`
2. Obtén el nuevo base64 del archivo de configuración
3. Actualiza la variable `RCLONE_CONFIG` en Railway

---

## 📊 Monitoreo

### Ver Logs de Rclone
Los logs de Rclone se guardan en:
```
/config/rclone/rclone.log
```

Puedes verlos desde Railway:
```bash
railway run cat /config/rclone/rclone.log
```

### Estadísticas de Uso
Rclone muestra estadísticas en los logs cada cierto tiempo:
- Archivos leídos
- Bytes transferidos
- Errores de API

---

## 🎯 Mejores Prácticas

1. **Organización**: Mantén una estructura de carpetas limpia y consistente
2. **Nombres**: Usa nombres de archivo compatibles con Plex (incluye año para películas)
3. **Subtítulos**: Coloca archivos .srt junto a los videos con el mismo nombre
4. **Backups**: Google Drive ya es un backup, pero considera tener copias locales de archivos importantes
5. **Monitoreo**: Revisa los logs periódicamente para detectar problemas

---

## 🔗 Enlaces Útiles

- **Rclone Docs**: https://rclone.org/drive/
- **Plex Naming Conventions**: https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/
- **Google Drive Limits**: https://developers.google.com/drive/api/guides/limits

---

## ✅ Resumen Rápido

1. ✅ Instalar Rclone en tu PC
2. ✅ Configurar remote de Google Drive
3. ✅ Subir películas a Google Drive con estructura correcta
4. ✅ Obtener configuración en base64
5. ✅ Agregar variables en Railway
6. ✅ Agregar bibliotecas en Plex apuntando a `/mnt/gdrive`

**¡Listo! Ahora puedes disfrutar de tus películas en Plex con almacenamiento ilimitado en Google Drive!** 🎉
