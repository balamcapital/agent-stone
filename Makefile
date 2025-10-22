.PHONY: help build up down logs restart clean dev full

# Variables
COMPOSE = docker compose
SERVICE = mastra

# Ayuda por defecto
help:
	@echo "🚀 Mastra Docker - Comandos Disponibles"
	@echo ""
	@echo "  make build       - Construir imágenes Docker"
	@echo "  make up          - Iniciar servicios (producción)"
	@echo "  make down        - Detener servicios"
	@echo "  make logs        - Ver logs en tiempo real"
	@echo "  make restart     - Reiniciar Mastra"
	@echo "  make clean       - Limpiar todo (contenedores + volúmenes)"
	@echo "  make dev         - Modo desarrollo (con hot-reload)"
	@echo "  make full        - Modo completo (todos los servicios)"
	@echo "  make shell       - Abrir shell en contenedor Mastra"
	@echo "  make ps          - Ver estado de servicios"
	@echo "  make backup      - Hacer backup de la base de datos"
	@echo ""

# Build de imágenes
build:
	@echo "🔨 Construyendo imágenes Docker..."
	$(COMPOSE) build

# Build sin cache
build-clean:
	@echo "🔨 Construyendo imágenes sin cache..."
	$(COMPOSE) build --no-cache

# Iniciar servicios en producción
up:
	@echo "🚀 Iniciando servicios..."
	$(COMPOSE) up -d
	@echo "✅ Servicios iniciados"
	@$(COMPOSE) ps

# Iniciar en foreground
up-fg:
	@echo "🚀 Iniciando servicios en foreground..."
	$(COMPOSE) up

# Detener servicios
down:
	@echo "🛑 Deteniendo servicios..."
	$(COMPOSE) down

# Ver logs
logs:
	@echo "📋 Logs de Mastra (Ctrl+C para salir)..."
	$(COMPOSE) logs -f $(SERVICE)

# Ver logs de todos los servicios
logs-all:
	@echo "📋 Logs de todos los servicios..."
	$(COMPOSE) logs -f

# Reiniciar Mastra
restart:
	@echo "🔄 Reiniciando Mastra..."
	$(COMPOSE) restart $(SERVICE)
	@echo "✅ Mastra reiniciado"

# Limpiar todo
clean:
	@echo "🧹 Limpiando contenedores y volúmenes..."
	$(COMPOSE) down -v
	@echo "✅ Limpieza completada"

# Limpieza profunda
clean-all: clean
	@echo "🧹 Limpieza profunda del sistema Docker..."
	docker system prune -af --volumes
	@echo "✅ Limpieza profunda completada"

# Modo desarrollo
dev:
	@echo "🔥 Iniciando en modo desarrollo..."
	$(COMPOSE) --profile dev up

# Modo desarrollo en background
dev-bg:
	@echo "🔥 Iniciando en modo desarrollo (background)..."
	$(COMPOSE) --profile dev up -d
	@$(COMPOSE) logs -f $(SERVICE)

# Modo completo
full:
	@echo "🌟 Iniciando en modo completo..."
	$(COMPOSE) --profile full up -d
	@echo "✅ Todos los servicios iniciados"
	@$(COMPOSE) ps

# Shell en Mastra
shell:
	@echo "💻 Abriendo shell en contenedor Mastra..."
	$(COMPOSE) exec $(SERVICE) sh

# Shell en PostgreSQL
psql:
	@echo "🗄️ Abriendo psql..."
	$(COMPOSE) exec postgres psql -U postgres -d mastra

# Ver estado de servicios
ps:
	@$(COMPOSE) ps

# Stats de recursos
stats:
	@docker stats --no-stream

# Backup de base de datos
backup:
	@./scripts/backup-db.sh

# Restaurar base de datos
restore:
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Error: Especifica el archivo con FILE=archivo.sql.gz"; \
		echo "Ejemplo: make restore FILE=backups/backup.sql.gz"; \
	else \
		./scripts/restore-db.sh $(FILE); \
	fi

# Verificar configuración
config:
	@$(COMPOSE) config

# Verificar salud
health:
	@echo "🏥 Verificando salud de servicios..."
	@curl -f http://localhost:4111/api/health 2>/dev/null && echo "✅ Mastra OK" || echo "❌ Mastra no responde"
	@$(COMPOSE) exec postgres pg_isready -U postgres > /dev/null && echo "✅ PostgreSQL OK" || echo "❌ PostgreSQL no responde"

# Pull de imágenes base
pull:
	@echo "📥 Descargando imágenes base..."
	$(COMPOSE) pull

# Inicialización completa
init:
	@./scripts/init.sh

# Desarrollo rápido (rebuild + restart)
dev-reload:
	@./scripts/dev-reload.sh

# Ver variables de entorno
env:
	@echo "🔐 Variables de entorno (sin valores sensibles):"
	@$(COMPOSE) exec $(SERVICE) env | grep -v "API_KEY\|PASSWORD\|SECRET" || true
