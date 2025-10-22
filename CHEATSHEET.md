# 🚀 Mastra Docker - Cheat Sheet

## Inicio Rápido

```bash
# Setup inicial
cp .env.example .env              # Copiar variables de entorno
./scripts/init.sh                 # Iniciar todo automáticamente

# Ver estado
docker compose ps                 # Estado de servicios
docker compose logs -f mastra     # Ver logs en tiempo real
```

---

## 🐳 Comandos Docker Compose

### Iniciar/Detener Servicios

```bash
# Iniciar todos los servicios (background)
docker compose up -d

# Iniciar solo algunos servicios
docker compose up -d postgres mastra

# Detener todo
docker compose down

# Detener y eliminar volúmenes (¡CUIDADO! Borra datos)
docker compose down -v

# Reiniciar un servicio
docker compose restart mastra
docker compose restart postgres

# Pausar servicios
docker compose pause
docker compose unpause
```

### Logs y Debugging

```bash
# Ver todos los logs
docker compose logs

# Logs de un servicio específico
docker compose logs mastra
docker compose logs postgres

# Logs en tiempo real (seguir)
docker compose logs -f
docker compose logs -f mastra

# Últimas 100 líneas
docker compose logs --tail=100 mastra

# Logs con timestamps
docker compose logs -t mastra
```

### Builds

```bash
# Build de imágenes
docker compose build

# Build sin cache (forzar rebuild completo)
docker compose build --no-cache

# Build de un servicio específico
docker compose build mastra

# Build y arrancar
docker compose up -d --build
```

---

## 📊 Inspección y Monitoreo

```bash
# Ver estado de contenedores
docker compose ps
docker compose ps -a              # Incluir detenidos

# Recursos usados
docker stats

# Inspeccionar un servicio
docker compose exec mastra sh     # Shell en contenedor
docker compose exec postgres psql -U postgres

# Ver configuración
docker compose config             # Ver docker-compose procesado
docker compose config --services  # Listar servicios
```

---

## 🗄️ Base de Datos

```bash
# Acceder a PostgreSQL
docker compose exec postgres psql -U postgres -d mastra

# Backup
./scripts/backup-db.sh

# Restaurar
./scripts/restore-db.sh backups/archivo.sql.gz

# Ver tablas
docker compose exec postgres psql -U postgres -d mastra -c '\dt'

# Ejecutar SQL
docker compose exec postgres psql -U postgres -d mastra -c 'SELECT * FROM ...'
```

---

## 📜 Scripts Personalizados

```bash
# Inicialización completa
./scripts/init.sh                 # Modo producción
./scripts/init.sh --dev          # Modo desarrollo
./scripts/init.sh --full         # Todos los servicios
./scripts/init.sh --clean        # Limpiar y reiniciar

# Desarrollo
./scripts/dev-reload.sh          # Reinicio rápido

# Base de datos
./scripts/backup-db.sh           # Crear backup
./scripts/restore-db.sh <file>   # Restaurar backup
```

---

## 🔧 NPM Scripts

```bash
# Desarrollo local (sin Docker)
npm run dev
npm run build
npm start

# Docker
npm run docker:build            # Build imagen
npm run docker:up               # Iniciar servicios
npm run docker:down             # Detener servicios
npm run docker:logs             # Ver logs
npm run docker:dev              # Modo desarrollo
npm run docker:full             # Modo completo
npm run docker:clean            # Limpiar todo
npm run docker:restart          # Reiniciar Mastra
```

---

## 🌐 Perfiles Docker Compose

```bash
# Producción (por defecto)
docker compose up -d
# → Mastra + PostgreSQL

# Desarrollo
docker compose --profile dev up -d
# → + PgAdmin + Hot Reload

# Completo
docker compose --profile full up -d
# → + Redis + todas las herramientas
```

---

## 🧹 Limpieza

```bash
# Detener y limpiar contenedores
docker compose down

# + Eliminar volúmenes
docker compose down -v

# + Eliminar imágenes
docker compose down --rmi all

# Limpiar todo Docker
docker system prune -af

# Limpiar volúmenes huérfanos
docker volume prune -f

# Limpiar completo del proyecto
./scripts/init.sh --clean
```

---

## 🔍 Troubleshooting

```bash
# Ver procesos en un contenedor
docker compose exec mastra ps aux

# Variables de entorno
docker compose exec mastra env

# Verificar conectividad a DB
docker compose exec mastra nc -zv postgres 5432

# Inspeccionar red
docker network inspect agent-stone_mastra-network

# Ver volúmenes
docker volume ls
docker volume inspect mastra-postgres-data

# Verificar salud de servicios
docker compose ps --format json | jq '.[] | {name: .Name, health: .Health}'
```

---

## 📦 Gestión de Volúmenes

```bash
# Listar volúmenes
docker volume ls

# Inspeccionar volumen
docker volume inspect mastra-postgres-data

# Backup manual de volumen
docker run --rm -v mastra-postgres-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/postgres-data.tar.gz /data

# Restaurar volumen
docker run --rm -v mastra-postgres-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/postgres-data.tar.gz -C /
```

---

## 🚀 Deployment

```bash
# Tag para registry
docker tag agent-stone:latest registry.com/agent-stone:v1.0.0

# Push a registry
docker push registry.com/agent-stone:v1.0.0

# Pull desde registry
docker pull registry.com/agent-stone:v1.0.0

# Save/Load imagen (sin registry)
docker save agent-stone:latest | gzip > agent-stone.tar.gz
docker load < agent-stone.tar.gz
```

---

## 🔐 Accesos Rápidos

### URLs

```
Mastra App:      http://localhost:4111
PgAdmin:         http://localhost:5050  (modo dev)
PostgreSQL:      localhost:5432
Redis:           localhost:6379  (modo full)
Debugger:        localhost:9229  (modo dev)
```

### Credenciales por Defecto

```env
# PostgreSQL
User:     postgres
Password: postgres
Database: mastra

# PgAdmin
Email:    admin@mastra.local
Password: admin
```

---

## ⚡ Comandos de Una Línea

```bash
# Ver todos los logs filtrados
docker compose logs | grep ERROR

# Reinicio completo
docker compose down && docker compose up -d

# Ver uso de recursos por servicio
docker stats --no-stream

# Ejecutar comando en Mastra
docker compose exec mastra npm run build

# Copiar archivo desde contenedor
docker compose cp mastra:/app/logs/app.log ./logs/

# Copiar archivo a contenedor
docker compose cp ./config.json mastra:/app/config.json

# Ver IPs de contenedores
docker compose ps -q | xargs docker inspect \
  -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

---

## 📝 Variables de Entorno Importantes

```env
# Cambiar puertos
MASTRA_PORT=4111
POSTGRES_PORT=5432
REDIS_PORT=6379
PGADMIN_PORT=5050

# Configuración
NODE_ENV=production|development
MASTRA_LOG_LEVEL=debug|info|warn|error

# API Keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_GENERATIVE_AI_API_KEY=...
```

---

## 🎯 Workflows Comunes

### Desarrollo Diario

```bash
# Iniciar día
./scripts/init.sh --dev

# Durante desarrollo (en otra terminal)
docker compose logs -f mastra

# Reiniciar tras cambios grandes
./scripts/dev-reload.sh

# Fin del día
docker compose down
```

### Actualizar Dependencias

```bash
# Actualizar package.json
npm update

# Rebuild imagen
docker compose build --no-cache mastra

# Reiniciar
docker compose up -d mastra
```

### Investigar un Error

```bash
# Ver logs
docker compose logs --tail=200 mastra

# Entrar al contenedor
docker compose exec mastra sh

# Revisar archivos
ls -la /app
cat /app/.mastra/output/index.mjs

# Ver variables de entorno
env | grep -i mastra
```

### Cambiar de Rama Git

```bash
# Detener servicios
docker compose down

# Cambiar rama
git checkout otra-rama

# Rebuild y arrancar
docker compose up -d --build
```

---

## 💡 Tips y Trucos

### Auto-restart al cambiar .env

```bash
# Añadir a .env
COMPOSE_PROJECT_NAME=agent-stone

# Reiniciar automáticamente
docker compose up -d --force-recreate
```

### Ver solo servicios en ejecución

```bash
docker compose ps --services --filter "status=running"
```

### Exportar logs a archivo

```bash
docker compose logs > logs/docker-$(date +%Y%m%d).log
```

### Health Check Manual

```bash
# Verificar salud de Mastra
curl http://localhost:4111/api/health

# PostgreSQL
docker compose exec postgres pg_isready -U postgres
```

---

## 📚 Referencias Rápidas

- [Docker Compose CLI](https://docs.docker.com/compose/reference/)
- [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)
- [Mastra Docs](https://mastra.ai/docs)
- [Proyecto README](README.md)

---

**Tip**: Guarda este archivo como referencia rápida! 📌
