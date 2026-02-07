# 🔄 Sincronización con el Repositorio Original

Este documento explica cómo mantener tu fork actualizado con el repositorio original de Plex Media Server.

---

## 🤖 Sincronización Automática (Recomendado)

### GitHub Actions (Ya Configurado)

He configurado un workflow de GitHub Actions que sincroniza automáticamente tu fork con el repositorio original **cada día a las 00:00 UTC**.

**Archivo**: `.github/workflows/sync-upstream.yml`

#### ¿Qué hace?
1. Se ejecuta automáticamente cada día
2. Descarga los cambios del repositorio original (`plexinc/pms-docker`)
3. Los fusiona con tu rama `master`
4. Hace push automáticamente a tu fork

#### Ejecución Manual
También puedes ejecutarlo manualmente:
1. Ve a tu repositorio en GitHub
2. Click en **Actions**
3. Selecciona **Sync with Upstream**
4. Click en **Run workflow**

---

## 🖐️ Sincronización Manual

Si prefieres sincronizar manualmente desde tu terminal local:

### Paso 1: Verificar Remotes
```bash
git remote -v
```

Deberías ver:
```
origin    https://github.com/Kennethguerra3/pms-docker-railway.git (fetch)
origin    https://github.com/Kennethguerra3/pms-docker-railway.git (push)
upstream  https://github.com/plexinc/pms-docker.git (fetch)
upstream  https://github.com/plexinc/pms-docker.git (push)
```

### Paso 2: Descargar Cambios del Upstream
```bash
git fetch upstream
```

### Paso 3: Fusionar Cambios
```bash
git checkout master
git merge upstream/master
```

### Paso 4: Subir a tu Fork
```bash
git push origin master
```

---

## 🌐 Sincronización desde GitHub Web (Más Fácil)

GitHub también permite sincronizar desde la interfaz web:

1. Ve a tu repositorio: `https://github.com/Kennethguerra3/pms-docker-railway`
2. Si hay cambios en el upstream, verás un mensaje:
   > **This branch is X commits behind plexinc:master**
3. Click en **Sync fork** → **Update branch**

---

## ⚠️ Resolución de Conflictos

Si hay conflictos entre tus archivos Railway y los cambios del upstream:

### Opción 1: Mantener tus Archivos Railway
```bash
git checkout master --ours railway.json railway.toml README.railway.md
git add railway.json railway.toml README.railway.md
git commit -m "chore: Keep Railway configuration files"
```

### Opción 2: Revisar Conflictos Manualmente
```bash
# Ver archivos en conflicto
git status

# Editar manualmente los archivos
# Luego:
git add <archivos-resueltos>
git commit -m "chore: Resolve merge conflicts"
```

---

## 📊 Verificar Estado de Sincronización

### Desde Terminal
```bash
# Ver commits que tu fork tiene pero upstream no
git log upstream/master..master

# Ver commits que upstream tiene pero tu fork no
git log master..upstream/master
```

### Desde GitHub
En la página principal de tu repositorio verás:
- ✅ **This branch is up to date with plexinc:master** → Sincronizado
- ⚠️ **This branch is X commits behind plexinc:master** → Necesitas sincronizar
- 📝 **This branch is X commits ahead of plexinc:master** → Tienes cambios adicionales (tus archivos Railway)

---

## 🎯 Mejores Prácticas

1. **Nunca modifiques archivos del upstream**: Solo agrega archivos nuevos (como `railway.json`, `railway.toml`, etc.)
2. **Sincroniza regularmente**: Al menos una vez por semana
3. **Revisa los changelogs**: Antes de sincronizar, revisa los cambios en [plexinc/pms-docker/releases](https://github.com/plexinc/pms-docker/releases)
4. **Prueba después de sincronizar**: Verifica que tu Railway Template siga funcionando

---

## 🔗 Enlaces Útiles

- **Tu Fork**: https://github.com/Kennethguerra3/pms-docker-railway
- **Repositorio Original**: https://github.com/plexinc/pms-docker
- **GitHub Actions**: https://github.com/Kennethguerra3/pms-docker-railway/actions
