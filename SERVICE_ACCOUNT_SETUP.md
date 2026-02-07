# 🎬 Configuración de Google Drive con Service Account (Método Simple)

> ⏱️ **Tiempo estimado:** 5 minutos  
> 💻 **Requisitos:** Solo un navegador web  
> ✅ **Sin instalaciones:** No necesitas instalar nada en tu PC

---

## 📋 ¿Qué es una Service Account?

Una **Service Account** es como un "robot" que puede acceder a tu Google Drive. En lugar de usar tu cuenta personal, creas una cuenta especial solo para Plex.

**Ventajas:**
- ✅ **Súper simple**: Solo copiar/pegar un archivo JSON
- ✅ **Sin instalar Rclone** en tu PC
- ✅ **Nunca expira**: No necesitas renovar credenciales
- ✅ **Más seguro**: Solo tiene acceso a las carpetas que compartas

---

## 🚀 Paso 1: Crear Proyecto en Google Cloud Console

### 1.1 Ir a Google Cloud Console

1. Abre tu navegador
2. Ve a: **https://console.cloud.google.com**
3. Inicia sesión con tu cuenta de Google

### 1.2 Crear Nuevo Proyecto

1. Haz clic en el selector de proyectos (arriba a la izquierda)
2. Clic en **"Nuevo Proyecto"**
3. Nombre del proyecto: `Plex Media Server` (o el que prefieras)
4. Clic en **"Crear"**
5. Espera 10-15 segundos a que se cree

---

## 🔌 Paso 2: Habilitar Google Drive API

### 2.1 Ir a APIs y Servicios

1. En el menú lateral (☰), busca **"APIs y servicios"**
2. Clic en **"Biblioteca"**

### 2.2 Habilitar Drive API

1. En el buscador, escribe: `Google Drive API`
2. Haz clic en **"Google Drive API"**
3. Clic en el botón azul **"Habilitar"**
4. Espera a que se habilite (5-10 segundos)

---

## 👤 Paso 3: Crear Service Account

### 3.1 Ir a Service Accounts

1. En el menú lateral (☰), ve a **"IAM y administración"**
2. Clic en **"Cuentas de servicio"**

### 3.2 Crear Cuenta

1. Clic en **"+ Crear cuenta de servicio"** (arriba)
2. Rellena los campos:
   - **Nombre:** `plex-gdrive`
   - **ID:** Se genera automáticamente
   - **Descripción:** `Service Account para Plex Media Server`
3. Clic en **"Crear y continuar"**
4. En "Otorgar acceso", **OMITIR** (no selecciones ningún rol)
5. Clic en **"Continuar"**
6. Clic en **"Listo"**

---

## 🔑 Paso 4: Descargar Credenciales JSON

### 4.1 Crear Clave

1. En la lista de cuentas de servicio, busca `plex-gdrive`
2. Haz clic en el **email** de la cuenta (algo como `plex-gdrive@...`)
3. Ve a la pestaña **"Claves"**
4. Clic en **"Agregar clave"** → **"Crear clave nueva"**
5. Selecciona tipo: **JSON**
6. Clic en **"Crear"**
7. Se descargará un archivo `.json` automáticamente

### 4.2 Copiar Email de Service Account

**¡IMPORTANTE!** Copia el email de la Service Account, lo necesitarás en el siguiente paso.

El email se ve así:
```
plex-gdrive@tu-proyecto-123456.iam.gserviceaccount.com
```

Puedes encontrarlo en:
- La lista de Service Accounts
- Dentro del archivo JSON descargado (campo `client_email`)

---

## 📁 Paso 5: Compartir Carpeta de Google Drive

### 5.1 Crear Carpeta en Google Drive

1. Ve a **https://drive.google.com**
2. Clic en **"Nuevo"** → **"Carpeta"**
3. Nombre: `Plex`
4. Clic en **"Crear"**

### 5.2 Crear Subcarpetas (Opcional pero Recomendado)

Dentro de la carpeta `Plex`, crea:
- `Movies` (para películas)
- `TV Shows` (para series)
- `Music` (para música)

### 5.3 Compartir con Service Account

1. **Clic derecho** en la carpeta `Plex`
2. Selecciona **"Compartir"**
3. En "Agregar personas y grupos", **pega el email de la Service Account**:
   ```
   plex-gdrive@tu-proyecto-123456.iam.gserviceaccount.com
   ```
4. Cambia el permiso a **"Editor"** (no "Lector")
5. **DESACTIVA** la casilla "Notificar a las personas"
6. Clic en **"Compartir"**

---

## ⚙️ Paso 6: Configurar en Railway

### 6.1 Abrir Archivo JSON

1. Busca el archivo `.json` que descargaste (probablemente en `Descargas`)
2. Ábrelo con **Bloc de notas** o cualquier editor de texto
3. **Selecciona TODO el contenido** (Ctrl+A)
4. **Copia** (Ctrl+C)

### 6.2 Configurar Variables en Railway

1. Ve a tu proyecto en **Railway Dashboard**
2. Selecciona tu servicio de Plex
3. Ve a la pestaña **"Variables"**
4. Agrega/edita las siguientes variables:

| Variable | Valor |
|----------|-------|
| `ENABLE_RCLONE` | `true` |
| `RCLONE_SERVICE_ACCOUNT_JSON` | **Pegar todo el contenido del JSON** |
| `RCLONE_REMOTE_NAME` | `gdrive` (dejar por defecto) |
| `RCLONE_REMOTE_PATH` | `/Plex` (o la ruta de tu carpeta) |

### 6.3 Guardar y Redesplegar

1. Clic en **"Save"** o **"Deploy"**
2. Espera a que Railway redespliegue el contenedor (~2-3 minutos)

---

## 📤 Paso 7: Subir Películas

### 7.1 Organizar Archivos

Sube tus películas a Google Drive siguiendo esta estructura:

```
Google Drive/
└── Plex/
    ├── Movies/
    │   ├── Avatar (2009)/
    │   │   └── Avatar (2009).mkv
    │   ├── Inception (2010)/
    │   │   └── Inception (2010).mp4
    │   └── ...
    └── TV Shows/
        ├── Breaking Bad/
        │   ├── Season 01/
        │   │   ├── Breaking Bad - S01E01.mkv
        │   │   └── ...
        │   └── ...
        └── ...
```

### 7.2 Métodos para Subir

**Opción 1: Navegador Web**
- Ve a drive.google.com
- Arrastra archivos a la carpeta

**Opción 2: App de Escritorio**
- Instala Google Drive para escritorio
- Sincroniza la carpeta Plex

**Opción 3: App Móvil**
- Usa la app de Google Drive
- Sube desde tu teléfono

---

## 🎬 Paso 8: Configurar Bibliotecas en Plex

### 8.1 Acceder a Plex

1. Abre Plex desde tu URL de Railway: `https://tu-app.railway.app:32400/web`
2. Inicia sesión con tu cuenta de Plex

### 8.2 Agregar Biblioteca

1. En el menú lateral, clic en **"+"** junto a "Bibliotecas"
2. Selecciona el tipo: **"Películas"**, **"Series"**, etc.
3. Clic en **"Siguiente"**
4. Clic en **"Examinar carpeta"**
5. Navega a: `/mnt/gdrive/Plex/Movies` (o la ruta correspondiente)
6. Clic en **"Agregar"**
7. Configura opciones adicionales si deseas
8. Clic en **"Agregar biblioteca"**

### 8.3 Escanear Contenido

Plex escaneará automáticamente la carpeta y agregará las películas.

---

## 🔍 Verificación

### Comprobar que Todo Funciona

1. **Ver logs de Railway:**
   ```
   [Rclone] Using Service Account authentication (recommended)
   [Rclone] ✓ Service Account configuration created
   [Rclone] ✓ Google Drive mounted successfully at /mnt/gdrive
   [Rclone] ✓ Read access verified
   ```

2. **Verificar en Plex:**
   - Las películas aparecen en la biblioteca
   - Puedes reproducir contenido sin problemas

---

## ❓ Troubleshooting

### Error: "Cannot read files"

**Causa:** La carpeta no está compartida con la Service Account.

**Solución:**
1. Ve a Google Drive
2. Clic derecho en la carpeta `Plex`
3. Verifica que el email de la Service Account aparece en "Compartido con"
4. Asegúrate de que tiene permisos de **"Editor"**

---

### Error: "Invalid JSON"

**Causa:** El JSON está mal copiado o corrupto.

**Solución:**
1. Abre el archivo JSON con un editor de texto
2. Verifica que empieza con `{` y termina con `}`
3. Copia TODO el contenido sin modificar nada
4. Pega en Railway sin espacios extra al inicio/final

---

### Error: "Google Drive API not enabled"

**Causa:** No habilitaste la API de Google Drive.

**Solución:**
1. Ve a Google Cloud Console
2. Selecciona tu proyecto
3. Ve a "APIs y servicios" → "Biblioteca"
4. Busca "Google Drive API"
5. Haz clic en "Habilitar"

---

### Las películas no aparecen en Plex

**Posibles causas:**

1. **Ruta incorrecta:**
   - Verifica que `RCLONE_REMOTE_PATH` apunte a la carpeta correcta
   - Ejemplo: Si tu carpeta se llama `Plex`, usa `/Plex`

2. **Estructura de carpetas incorrecta:**
   - Cada película debe estar en su propia carpeta
   - Ejemplo: `Movies/Avatar (2009)/Avatar (2009).mkv`

3. **Plex no ha escaneado:**
   - Ve a Bibliotecas → Opciones → "Escanear archivos de biblioteca"

---

### Buffering o reproducción lenta

**Causas comunes:**

1. **Archivo muy grande:**
   - Los archivos 4K pueden tardar en cargar
   - Considera usar calidades menores (1080p)

2. **Límites de API:**
   - Google Drive tiene límites de descarga
   - Solución: Espera unas horas y vuelve a intentar

3. **Conexión lenta:**
   - Verifica tu velocidad de internet
   - Mínimo recomendado: 25 Mbps para 1080p

---

## 🔒 Seguridad y Privacidad

### ¿Es seguro usar Service Account?

**SÍ**, es incluso más seguro que OAuth personal porque:

- ✅ Solo tiene acceso a carpetas que compartas explícitamente
- ✅ No usa tu contraseña personal
- ✅ Puedes revocar acceso en cualquier momento
- ✅ Google Cloud registra todos los accesos

### ¿Cómo revocar acceso?

**Método 1: Dejar de compartir**
1. Ve a Google Drive
2. Clic derecho en carpeta `Plex`
3. Elimina el email de la Service Account

**Método 2: Eliminar Service Account**
1. Ve a Google Cloud Console
2. IAM → Cuentas de servicio
3. Elimina `plex-gdrive`

---

## 💡 Consejos y Mejores Prácticas

### Organización de Archivos

**Para Películas:**
```
Movies/
├── Nombre de Película (Año)/
│   └── Nombre de Película (Año).ext
```

**Para Series:**
```
TV Shows/
├── Nombre de Serie/
│   ├── Season 01/
│   │   ├── Nombre - S01E01.ext
│   │   └── Nombre - S01E02.ext
```

### Nombres de Archivos

- ✅ Incluye el año: `Avatar (2009).mkv`
- ✅ Usa formato SxxExx para series: `Breaking Bad - S01E01.mkv`
- ❌ Evita caracteres especiales: `@`, `#`, `%`

### Gestión de Espacio

- Google Drive gratis: 15 GB
- Google One (100 GB): ~$2/mes
- Google Workspace (2 TB): ~$12/mes

---

## 🆚 Comparación: Service Account vs OAuth

| Característica | Service Account | OAuth Personal |
|----------------|-----------------|----------------|
| **Instalación en PC** | ❌ No requiere | ✅ Requiere Rclone |
| **Complejidad** | ⭐ Muy fácil | ⭐⭐⭐ Media |
| **Tiempo setup** | ~5 minutos | ~15 minutos |
| **Expiración** | ♾️ Nunca | ⚠️ Puede expirar |
| **Seguridad** | ✅ Acceso limitado | ⚠️ Acceso total |
| **Recomendado para** | Todos los usuarios | Usuarios avanzados |

---

## 📚 Recursos Adicionales

- [Documentación de Google Cloud Service Accounts](https://cloud.google.com/iam/docs/service-accounts)
- [Guía de Rclone para Google Drive](https://rclone.org/drive/)
- [Mejores prácticas de organización de Plex](https://support.plex.tv/articles/naming-and-organizing-your-movie-media-files/)

---

## ✅ Checklist Final

Antes de empezar a usar Plex, verifica:

- [ ] Proyecto creado en Google Cloud Console
- [ ] Google Drive API habilitada
- [ ] Service Account creada
- [ ] Archivo JSON descargado
- [ ] Carpeta `Plex` creada en Google Drive
- [ ] Carpeta compartida con email de Service Account (permisos de Editor)
- [ ] Variables configuradas en Railway (`ENABLE_RCLONE=true`, `RCLONE_SERVICE_ACCOUNT_JSON`)
- [ ] Servicio desplegado correctamente
- [ ] Películas subidas a Google Drive
- [ ] Biblioteca agregada en Plex apuntando a `/mnt/gdrive/Plex/Movies`
- [ ] Contenido visible y reproducible en Plex

---

## 🎉 ¡Listo!

Ahora tienes Plex configurado con Google Drive usando Service Account. Disfruta de tu biblioteca multimedia ilimitada! 🍿
