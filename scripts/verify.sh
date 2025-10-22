#!/bin/bash

# ============================================
# Script de Verificación del Entorno Docker
# ============================================

set -e

echo "🔍 Verificando entorno Docker de Mastra AI..."
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar
check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

# 1. Verificar Docker
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Verificando Docker..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker --version > /dev/null 2>&1
check "Docker instalado"

docker compose version > /dev/null 2>&1
check "Docker Compose instalado"

# 2. Verificar contenedores
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐳 Verificando Contenedores..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar si los contenedores están corriendo
MASTRA_STATUS=$(docker compose ps mastra --format json 2>/dev/null | grep -o '"State":"running"' || echo "")
POSTGRES_STATUS=$(docker compose ps postgres --format json 2>/dev/null | grep -o '"State":"running"' || echo "")

if [ -n "$MASTRA_STATUS" ]; then
    check "Contenedor Mastra corriendo"
else
    echo -e "${RED}✗${NC} Contenedor Mastra no está corriendo"
fi

if [ -n "$POSTGRES_STATUS" ]; then
    check "Contenedor PostgreSQL corriendo"
else
    echo -e "${RED}✗${NC} Contenedor PostgreSQL no está corriendo"
fi

# Mostrar estado detallado
echo ""
docker compose ps

# 3. Verificar health checks
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💚 Verificando Health Checks..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MASTRA_HEALTH=$(docker compose ps mastra --format json 2>/dev/null | grep -o '"Health":"healthy"' || echo "")
POSTGRES_HEALTH=$(docker compose ps postgres --format json 2>/dev/null | grep -o '"Health":"healthy"' || echo "")

if [ -n "$MASTRA_HEALTH" ]; then
    check "Mastra health check: healthy"
else
    echo -e "${YELLOW}⚠${NC} Mastra health check: no healthy (puede estar iniciando)"
fi

if [ -n "$POSTGRES_HEALTH" ]; then
    check "PostgreSQL health check: healthy"
else
    echo -e "${YELLOW}⚠${NC} PostgreSQL health check: no healthy"
fi

# 4. Verificar puertos
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔌 Verificando Puertos..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar puerto 4111 (Mastra)
if command -v lsof &> /dev/null; then
    lsof -i :4111 > /dev/null 2>&1
    check "Puerto 4111 (Mastra) abierto"
else
    nc -z localhost 4111 > /dev/null 2>&1
    check "Puerto 4111 (Mastra) abierto"
fi

# Verificar puerto 5432 (PostgreSQL)
if command -v lsof &> /dev/null; then
    lsof -i :5432 > /dev/null 2>&1
    check "Puerto 5432 (PostgreSQL) abierto"
else
    nc -z localhost 5432 > /dev/null 2>&1
    check "Puerto 5432 (PostgreSQL) abierto"
fi

# 5. Verificar conectividad HTTP
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Verificando Conectividad HTTP..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4111 2>/dev/null || echo "000")
if [ "$HTTP_STATUS" = "200" ]; then
    check "Mastra HTTP responde (status: $HTTP_STATUS)"
else
    echo -e "${YELLOW}⚠${NC} Mastra HTTP status: $HTTP_STATUS (esperando 200)"
fi

# 6. Verificar base de datos
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💾 Verificando Base de Datos..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

DB_CHECK=$(docker compose exec -T postgres psql -U postgres -d mastra -c "SELECT 1" 2>/dev/null || echo "")
if [ -n "$DB_CHECK" ]; then
    check "Conexión a PostgreSQL exitosa"
else
    echo -e "${RED}✗${NC} No se puede conectar a PostgreSQL"
fi

# Verificar extensiones
UUID_CHECK=$(docker compose exec -T postgres psql -U postgres -d mastra -c "SELECT * FROM pg_extension WHERE extname='uuid-ossp'" 2>/dev/null | grep uuid-ossp || echo "")
if [ -n "$UUID_CHECK" ]; then
    check "Extensión uuid-ossp instalada"
else
    echo -e "${YELLOW}⚠${NC} Extensión uuid-ossp no instalada"
fi

# 7. Verificar logs recientes
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Últimos Logs de Mastra..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
docker compose logs mastra --tail=5

# 8. Verificar estructura de archivos
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📁 Verificando Estructura de Archivos..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

[ -f "Dockerfile" ] && check "Dockerfile existe" || echo -e "${RED}✗${NC} Dockerfile no existe"
[ -f "docker-compose.yml" ] && check "docker-compose.yml existe" || echo -e "${RED}✗${NC} docker-compose.yml no existe"
[ -f "package.json" ] && check "package.json existe" || echo -e "${RED}✗${NC} package.json no existe"
[ -f "src/mastra/index.ts" ] && check "src/mastra/index.ts existe" || echo -e "${RED}✗${NC} src/mastra/index.ts no existe"
[ -f "mastra.config.ts" ] && check "mastra.config.ts existe" || echo -e "${RED}✗${NC} mastra.config.ts no existe"
[ -f ".env.example" ] && check ".env.example existe" || echo -e "${RED}✗${NC} .env.example no existe"

# 9. Verificar volúmenes
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💿 Verificando Volúmenes..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

POSTGRES_VOL=$(docker volume ls | grep postgres_data || echo "")
if [ -n "$POSTGRES_VOL" ]; then
    check "Volumen postgres_data existe"
else
    echo -e "${YELLOW}⚠${NC} Volumen postgres_data no existe"
fi

LOGS_VOL=$(docker volume ls | grep mastra_logs || echo "")
if [ -n "$LOGS_VOL" ]; then
    check "Volumen mastra_logs existe"
else
    echo -e "${YELLOW}⚠${NC} Volumen mastra_logs no existe"
fi

# Resumen final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Resumen"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "URLs de acceso:"
echo "  🌐 Mastra UI:     http://localhost:4111"
echo "  💾 PostgreSQL:    localhost:5432"
echo ""
echo "Comandos útiles:"
echo "  📋 Ver logs:      docker compose logs -f mastra"
echo "  🔄 Reiniciar:     docker compose restart"
echo "  ⏹️  Detener:       docker compose down"
echo "  🚀 Iniciar:       docker compose up -d"
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Verificación completada${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
