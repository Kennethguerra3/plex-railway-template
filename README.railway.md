# Plex Media Server - Railway Template

## 🚀 Despliegue Rápido

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

Esta es una plantilla oficial para desplegar **Plex Media Server** en Railway usando el repositorio oficial `plexinc/pms-docker`.

---

## 📋 Requisitos Previos

1. **Cuenta de Plex**: Necesitas una cuenta en [plex.tv](https://plex.tv)
2. **Claim Token**: Obtén tu token desde [https://plex.tv/claim](https://plex.tv/claim) (válido por 4 minutos)
3. **Cuenta de Railway**: Crea una cuenta gratuita en [railway.app](https://railway.app)

---

## ⚙️ Variables de Entorno Requeridas

### **PLEX_CLAIM** (Obligatorio)
- **Descripción**: Token de reclamación para vincular el servidor a tu cuenta.
- **Obtención**: Visita [https://plex.tv/claim](https://plex.tv/claim) y copia el token.
- **Nota**: El token expira en 4 minutos, así que úsalo inmediatamente después de obtenerlo.

### **ADVERTISE_IP** (Recomendado)
- **Descripción**: URL pública del servicio en Railway.
- **Formato**: `https://<tu-dominio>.up.railway.app:32400`
- **Ejemplo**: `https://plex-production.up.railway.app:32400`
- **Por qué es necesario**: Railway usa networking Bridge (aislado), no `host`. Sin esta variable, Plex no será accesible externamente.

### **TZ** (Opcional)
- **Descripción**: Zona horaria del servidor.
- **Default**: `UTC`
- **Ejemplos**: `America/New_York`, `Europe/Madrid`, `America/Mexico_City`

### **PLEX_UID / PLEX_GID** (Opcional)
- **Descripción**: User/Group ID para permisos de archivos.
- **Default**: `1000`
- **Uso**: Solo necesario si montas volúmenes externos con permisos específicos.

---

## 💾 Volúmenes Persistentes

Railway montará automáticamente tres volúmenes:

| Volumen | Ruta | Propósito |
|---------|------|-----------|
| `plex-config` | `/config` | **CRÍTICO**: Base de datos, metadatos, configuración |
| `plex-data` | `/data` | Archivos multimedia (películas, series, música) |
| `plex-transcode` | `/transcode` | Archivos temporales de transcodificación |

> **⚠️ IMPORTANTE**: El volumen `/config` contiene la base de datos de Plex. **NO LO ELIMINES** o perderás toda tu configuración.

---

## 🌐 Configuración de Red

### Puerto Principal
- **Puerto**: `32400/TCP`
- **Protocolo**: HTTP/HTTPS
- **Uso**: Interfaz web y streaming

### Puertos Adicionales (Expuestos pero no públicos en Railway)
- `8324/TCP`: Roku via Plex Companion
- `32469/TCP`: Plex DLNA Server
- `1900/UDP`: Plex DLNA Server Discovery
- `32410-32414/UDP`: Network Discovery

> **Nota**: Railway solo expone el puerto 32400 públicamente. Los demás puertos están disponibles internamente.

---

## 🔧 Configuración Post-Despliegue

### 1. Obtener la URL Pública
Después del despliegue, Railway te asignará una URL pública:
```
https://<nombre-servicio>.up.railway.app
```

### 2. Configurar ADVERTISE_IP
Ve a las variables de entorno en Railway y actualiza:
```
ADVERTISE_IP=https://<nombre-servicio>.up.railway.app:32400
```

### 3. Acceder a Plex
Visita:
```
https://<nombre-servicio>.up.railway.app:32400/web
```

### 4. Configuración Inicial
1. Inicia sesión con tu cuenta de Plex
2. Configura tus bibliotecas apuntando a `/data`
3. Ajusta las configuraciones de transcodificación según tus necesidades

---

## 📁 Almacenamiento de Archivos Multimedia

### ⭐ Opción Recomendada: Google Drive con Service Account (Súper Fácil)

Esta template incluye **dos métodos** para conectar Google Drive. El método de Service Account es el más simple:

#### 🎯 Método 1: Service Account (Recomendado)

✅ **Sin instalar nada en tu PC**  
✅ **Solo copiar/pegar un archivo JSON**  
✅ **Nunca expira**  
✅ **5 minutos de configuración**  
✅ **Almacenamiento ilimitado** (según tu plan de Google)  
✅ **Fácil gestión** desde Google Drive web/desktop  

**📖 Guía paso a paso**: [SERVICE_ACCOUNT_SETUP.md](SERVICE_ACCOUNT_SETUP.md)

**Pasos rápidos:**

1. Crear Service Account en Google Cloud Console
2. Descargar archivo JSON
3. Compartir carpeta de Google Drive con email de Service Account
4. Copiar JSON completo a Railway:
   - `ENABLE_RCLONE=true`
   - `RCLONE_SERVICE_ACCOUNT_JSON=<contenido-del-json>`
5. Subir películas a Google Drive
6. Agregar bibliotecas en Plex apuntando a `/mnt/gdrive`

---

#### 🔧 Método 2: OAuth Personal (Avanzado)

Para usuarios técnicos que prefieren OAuth:

⚠️ **Requiere instalar Rclone en tu PC**  
⚠️ **Configuración más compleja (15 minutos)**  
⚠️ **Requiere terminal/línea de comandos**  

**📖 Guía completa**: [GOOGLE_DRIVE_SETUP.md](GOOGLE_DRIVE_SETUP.md)

**Pasos:**

1. Instalar Rclone localmente
2. Configurar remote de Google Drive
3. Obtener configuración en base64
4. Agregar variables en Railway:
   - `ENABLE_RCLONE=true`
   - `RCLONE_CONFIG=<tu-config-base64>`
5. Subir películas y configurar Plex

---

### Otras Opciones

#### Volumen Railway Nativo

- Usa el volumen `/data` montado automáticamente
- **Limitación**: Tamaño limitado y costoso para grandes bibliotecas
- **Recomendado solo para**: Bibliotecas pequeñas (< 50GB)

#### Cloudflare R2 / AWS S3

- Almacenamiento en la nube económico
- Requiere configuración adicional de Rclone
- Ver [GOOGLE_DRIVE_SETUP.md](GOOGLE_DRIVE_SETUP.md) para instrucciones


---

## 🩺 Healthcheck

El servicio incluye un healthcheck automático:
- **Endpoint**: `http://localhost:32400/identity`
- **Intervalo**: Cada 5 segundos
- **Timeout**: 2 segundos
- **Reintentos**: 20 veces antes de marcar como unhealthy

---

## 🐛 Troubleshooting

### El servidor no es accesible externamente
- ✅ Verifica que `ADVERTISE_IP` esté configurado correctamente
- ✅ Asegúrate de que la URL incluya el puerto `:32400`
- ✅ Revisa los logs en Railway Dashboard

### El servidor se reinicia constantemente
- ✅ Verifica que el `PLEX_CLAIM` sea válido (no expirado)
- ✅ Revisa los logs para errores de permisos
- ✅ Asegúrate de que los volúmenes estén montados correctamente

### No puedo agregar bibliotecas
- ✅ Verifica que el volumen `/data` esté montado
- ✅ Asegúrate de tener archivos multimedia en `/data`
- ✅ Revisa los permisos con `PLEX_UID` y `PLEX_GID`

### Problemas de transcodificación
- ✅ Railway tiene recursos limitados en el plan gratuito
- ✅ Considera actualizar a un plan con más CPU/RAM
- ✅ Ajusta la calidad de transcodificación en Plex

---

## 📚 Recursos Adicionales

- [Documentación Oficial de Plex](https://support.plex.tv/)
- [Repositorio GitHub de pms-docker](https://github.com/plexinc/pms-docker)
- [Documentación de Railway](https://docs.railway.app/)
- [Foro de la Comunidad Plex](https://forums.plex.tv/)

---

## 📄 Licencia

Este proyecto usa el contenedor oficial de Plex Media Server. Consulta la [licencia de Plex](https://www.plex.tv/about/privacy-legal/plex-terms-of-service/) para más información.

---

## 🤝 Contribuciones

Si encuentras problemas o tienes sugerencias, abre un issue en el repositorio oficial de [plexinc/pms-docker](https://github.com/plexinc/pms-docker/issues).
