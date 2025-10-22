# 🚀 Mastra AI Framework - Entorno Dockerizado

<div align="center">

![Mastra Logo](https://mastra.ai/logo.svg)

**Framework TypeScript de última generación para construir agentes AI y aplicaciones inteligentes**

[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)
[![Node](https://img.shields.io/badge/Node.js-20+-green.svg)](https://nodejs.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

</div>

---

## 📋 Tabla de Contenidos

- [Características](#-características)
- [Requisitos Previos](#-requisitos-previos)
- [Inicio Rápido](#-inicio-rápido)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Configuración](#️-configuración)
- [Uso](#-uso)
- [Desarrollo](#-desarrollo)
- [Despliegue](#-despliegue)
- [Scripts Disponibles](#-scripts-disponibles)
- [Arquitectura](#-arquitectura)
- [Solución de Problemas](#-solución-de-problemas)
- [Recursos](#-recursos)

---

## ✨ Características

Este entorno dockerizado para Mastra incluye:

- 🐳 **Docker Multi-Stage**: Builds optimizados y imágenes ligeras
- 🗄️ **PostgreSQL**: Base de datos persistente para storage
- 🔥 **Hot Reload**: Desarrollo ágil con recarga automática
- 🔒 **Seguridad**: Usuarios no-root y mejores prácticas
- 📊 **Observabilidad**: Logging y health checks integrados
- 🎯 **Múltiples Perfiles**: Desarrollo, producción y completo
- 🛠️ **Scripts Auxiliares**: Automatización de tareas comunes
- 📦 **Redis & PgAdmin**: Servicios opcionales para desarrollo

---

## 🔧 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Docker Desktop** (v20.10+) - [Descargar](https://www.docker.com/products/docker-desktop)
- **Docker Compose** (v2.0+) - Incluido con Docker Desktop
- **Node.js** (v20+) - Solo para desarrollo local - [Descargar](https://nodejs.org/)
- **Git** - [Descargar](https://git-scm.com/)

### Verificar instalación:

```bash
docker --version
docker compose version
node --version
```

---

## 🚀 Inicio Rápido

### 1️⃣ Clonar el repositorio

```bash
git clone <tu-repositorio>
cd agent-stone
```

### 2️⃣ Configurar variables de entorno

```bash
cp .env.example .env
```

Edita `.env` y agrega tus API keys:

```env
# Necesitas al menos una de estas:
OPENAI_API_KEY=sk-your-openai-api-key-here
ANTHROPIC_API_KEY=sk-ant-your-anthropic-api-key-here
GOOGLE_GENERATIVE_AI_API_KEY=your-google-api-key-here
```

### 3️⃣ Iniciar el entorno

**Opción A: Usando el script de inicialización (Recomendado)**

```bash
./scripts/init.sh
```

**Opción B: Manualmente**

```bash
# Construir imágenes
docker compose build

# Iniciar servicios
docker compose up -d

# Ver logs
docker compose logs -f mastra
```

### 4️⃣ Verificar que funciona

Abre tu navegador en [http://localhost:4111](http://localhost:4111)

```bash
# Verificar estado de servicios
docker compose ps

# Ver logs en tiempo real
docker compose logs -f mastra
```

---

## 📁 Estructura del Proyecto

```
agent-stone/
├── 📄 Dockerfile              # Imagen optimizada multi-stage para producción
├── 📄 Dockerfile.dev          # Imagen para desarrollo con hot-reload
├── 📄 docker-compose.yml      # Orquestación de servicios
├── 📄 .dockerignore           # Exclusiones para build context
├── 📄 .env.example            # Variables de entorno de ejemplo
├── 📄 package.json            # Dependencias del proyecto
├── 📄 tsconfig.json           # Configuración TypeScript
├── 📄 mastra.config.ts        # Configuración de Mastra
│
├── 📂 src/                    # Código fuente
│   ├── 📄 index.ts           # Punto de entrada
│   ├── 📂 agents/            # Agentes AI
│   ├── 📂 workflows/         # Workflows y orquestación
│   └── 📂 tools/             # Herramientas personalizadas
│
├── 📂 scripts/                # Scripts de automatización
│   ├── 📄 init.sh            # Inicialización del entorno
│   ├── 📄 dev-reload.sh      # Recarga rápida en desarrollo
│   ├── 📄 backup-db.sh       # Backup de base de datos
│   └── 📄 restore-db.sh      # Restauración de base de datos
│
├── 📂 init-db/                # Scripts SQL de inicialización
├── 📂 logs/                   # Archivos de logs
└── 📂 backups/                # Backups de base de datos
```

---

## ⚙️ Configuración

### Variables de Entorno Principales

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `POSTGRES_USER` | Usuario de PostgreSQL | `postgres` |
| `POSTGRES_PASSWORD` | Contraseña de PostgreSQL | `postgres` |
| `POSTGRES_DB` | Nombre de la base de datos | `mastra` |
| `MASTRA_PORT` | Puerto de la aplicación | `4111` |
| `OPENAI_API_KEY` | API Key de OpenAI | - |
| `ANTHROPIC_API_KEY` | API Key de Anthropic | - |
| `GOOGLE_GENERATIVE_AI_API_KEY` | API Key de Google | - |
| `NODE_ENV` | Entorno de ejecución | `production` |

Ver `.env.example` para todas las opciones disponibles.

---

## 🎯 Uso

### Modos de Ejecución

#### 🏭 Modo Producción (por defecto)

```bash
docker compose up -d
```

Incluye:
- Mastra App (puerto 4111)
- PostgreSQL (puerto 5432)

#### 🔥 Modo Desarrollo

```bash
./scripts/init.sh --dev
# o
docker compose --profile dev up
```

Incluye todo lo anterior más:
- Hot-reload activado
- Debugging habilitado (puerto 9229)
- PgAdmin (puerto 5050)
- Volúmenes montados para código en vivo

#### 🌟 Modo Completo

```bash
./scripts/init.sh --full
# o
docker compose --profile full up -d
```

Incluye todo más:
- Redis para caché (puerto 6379)
- PgAdmin para gestión de DB

### Acceder a los Servicios

- **Mastra API**: http://localhost:4111
- **PgAdmin** (modo dev): http://localhost:5050
  - Email: `admin@mastra.local`
  - Password: `admin`
- **PostgreSQL**: `localhost:5432`
  - Database: `mastra`
  - User: `postgres`
  - Password: `postgres`

---

## 👨‍💻 Desarrollo

### Inicializar Mastra

Si aún no has inicializado Mastra localmente:

```bash
npm install
npx mastra init
```

Sigue las indicaciones para:
1. Seleccionar componentes (agents, workflows, scorers)
2. Elegir tu proveedor LLM preferido
3. Agregar ejemplos (recomendado para empezar)

### Crear un Agente

```bash
# Crear directorio para tu agente
mkdir -p src/agents

# Crear archivo del agente
cat > src/agents/my-agent.ts << 'EOF'
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';

export const myAgent = new Agent({
  name: 'My Agent',
  instructions: 'You are a helpful AI assistant.',
  model: openai('gpt-4o-mini'),
});
EOF
```

### Hot Reload en Desarrollo

En modo desarrollo, los cambios en `src/` se reflejan automáticamente:

```bash
# Iniciar en modo dev
./scripts/init.sh --dev

# Editar código en src/
# Los cambios se recargan automáticamente
```

### Recarga Rápida

Si necesitas reiniciar solo el contenedor de Mastra:

```bash
./scripts/dev-reload.sh
```

---

## 🚢 Despliegue

### Build para Producción

```bash
# Construir imagen optimizada
docker compose build mastra

# Verificar tamaño de imagen
docker images | grep agent-stone
```

### Despliegue en la Nube

Este entorno está listo para desplegarse en:

- **AWS ECS/Fargate**
- **Google Cloud Run**
- **Azure Container Instances**
- **DigitalOcean App Platform**
- **Railway, Fly.io, Render**

#### Ejemplo: Push a Registry

```bash
# Tag de imagen
docker tag agent-stone:latest your-registry.com/agent-stone:v1.0.0

# Push a registry
docker push your-registry.com/agent-stone:v1.0.0
```

---

## 📜 Scripts Disponibles

### NPM Scripts

```bash
npm run dev              # Desarrollo local (sin Docker)
npm run build            # Build de producción
npm start                # Ejecutar app compilada
npm run docker:build     # Construir imagen Docker
npm run docker:up        # Iniciar servicios
npm run docker:down      # Detener servicios
npm run docker:logs      # Ver logs de Mastra
npm run docker:dev       # Modo desarrollo
npm run docker:full      # Todos los servicios
npm run docker:clean     # Limpiar todo
```

### Scripts de Shell

```bash
./scripts/init.sh              # Inicialización completa
./scripts/init.sh --dev        # Modo desarrollo
./scripts/init.sh --full       # Todos los servicios
./scripts/init.sh --clean      # Limpiar y reiniciar
./scripts/dev-reload.sh        # Recarga rápida
./scripts/backup-db.sh         # Backup de base de datos
./scripts/restore-db.sh <file> # Restaurar desde backup
```

---

## 🏗️ Arquitectura

### Diagrama de Servicios

```
┌─────────────┐
│   Cliente   │
│    HTTP     │
└──────┬──────┘
       │ Port 4111
       ▼
┌─────────────┐      ┌──────────────┐
│   Mastra    │─────▶│  PostgreSQL  │
│     App     │      │   Database   │
└──────┬──────┘      └──────────────┘
       │
       │ (Opcional)
       ▼
┌─────────────┐
│    Redis    │
│    Cache    │
└─────────────┘
```

### Dockerfile Multi-Stage

El Dockerfile utiliza 3 stages:

1. **Dependencies**: Instala dependencias de producción
2. **Builder**: Compila el código TypeScript
3. **Runtime**: Imagen final optimizada y segura

Beneficios:
- ✅ Imagen final pequeña (~150MB vs ~500MB)
- ✅ Sin dependencias de desarrollo
- ✅ Cache optimizado
- ✅ Builds más rápidos

---

## 🔍 Solución de Problemas

### Los contenedores no inician

```bash
# Verificar logs
docker compose logs

# Verificar estado de Docker
docker info

# Reiniciar Docker Desktop
```

### Puerto ya en uso

```bash
# Encontrar proceso usando puerto 4111
lsof -i :4111

# O cambiar puerto en .env
MASTRA_PORT=4112
```

### Base de datos no conecta

```bash
# Verificar que PostgreSQL está corriendo
docker compose ps postgres

# Ver logs de PostgreSQL
docker compose logs postgres

# Recrear base de datos
docker compose down -v
docker compose up -d
```

### Permisos de archivos

```bash
# En macOS/Linux, dar permisos a scripts
chmod +x scripts/*.sh

# Verificar propietario de volúmenes
docker compose exec mastra ls -la /app
```

### Limpiar todo y empezar de cero

```bash
./scripts/init.sh --clean
# o
docker compose down -v
docker system prune -af
rm -rf node_modules .mastra
```

---

## 📚 Recursos

### Documentación Oficial

- [Mastra Docs](https://mastra.ai/docs)
- [Mastra GitHub](https://github.com/mastra-ai/mastra)
- [Ejemplos](https://mastra.ai/examples)
- [Templates](https://mastra.ai/templates)

### Tutoriales

- [Building Your First Agent](https://mastra.ai/course)
- [Workflow Guide](https://mastra.ai/docs/workflows/overview)
- [RAG Implementation](https://mastra.ai/docs/rag/overview)

### Comunidad

- [Discord](https://discord.gg/BTYqqHKUrf)
- [Twitter/X](https://x.com/mastra_ai)
- [YouTube](https://www.youtube.com/@mastra-ai)

### Proveedores LLM

- [OpenAI](https://platform.openai.com/)
- [Anthropic](https://www.anthropic.com/)
- [Google AI](https://ai.google.dev/)
- [Más proveedores](https://mastra.ai/models)

---

## 📝 Notas Adicionales

### Seguridad

- Las imágenes Docker ejecutan como usuario no-root (`mastra:1001`)
- No se incluyen secrets en las imágenes
- Variables sensibles solo en `.env` (git-ignored)
- Health checks para todos los servicios

### Optimizaciones

- Build cache de Docker optimizado
- Multi-stage para reducir tamaño
- `.dockerignore` para excluir archivos innecesarios
- Dependencias instaladas solo una vez

### Backups

Los backups se crean automáticamente con compresión:

```bash
# Crear backup
./scripts/backup-db.sh

# Restaurar
./scripts/restore-db.sh backups/mastra_backup_20231020_120000.sql.gz
```

---

## 🤝 Contribuir

¿Encontraste un bug o tienes una sugerencia?

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/amazing-feature`)
3. Commit tus cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**Balam Palma**  
GitHub: [@balamcapital](https://github.com/balamcapital)

---

## ⭐ ¿Te resultó útil?

Si este entorno Docker te ayudó, considera:
- ⭐ Darle una estrella al repositorio
- 🐦 Compartirlo en redes sociales
- 🤝 Contribuir con mejoras

---

<div align="center">

**¡Construyamos el futuro con AI! 🚀**

Hecho con ❤️ usando [Mastra](https://mastra.ai)

**Agent Stone - Alan Stone** 🎯  
_Un repositorio para estudiar y construir agentes AI_

</div>
