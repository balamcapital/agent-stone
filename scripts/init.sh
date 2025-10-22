#!/bin/bash

# Script de inicialización para Mastra Docker Environment
# Autor: Balam Palma
# Descripción: Prepara y lanza el entorno Mastra dockerizado

set -e

echo "🚀 Inicializando entorno Mastra Docker..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes coloreados
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar que Docker está instalado
check_docker() {
    print_info "Verificando instalación de Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor instala Docker Desktop desde https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker no está corriendo. Por favor inicia Docker Desktop."
        exit 1
    fi
    
    print_success "Docker está instalado y corriendo"
}

# Verificar que Docker Compose está disponible
check_docker_compose() {
    print_info "Verificando Docker Compose..."
    
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose no está disponible."
        exit 1
    fi
    
    print_success "Docker Compose está disponible"
}

# Crear archivo .env si no existe
setup_env() {
    print_info "Configurando variables de entorno..."
    
    if [ ! -f .env ]; then
        print_warning "Archivo .env no encontrado. Copiando desde .env.example..."
        cp .env.example .env
        print_warning "Por favor edita el archivo .env y agrega tus API keys antes de continuar."
        print_info "Necesitarás al menos una de estas API keys:"
        echo "  - OPENAI_API_KEY"
        echo "  - ANTHROPIC_API_KEY"
        echo "  - GOOGLE_GENERATIVE_AI_API_KEY"
        echo ""
        read -p "¿Deseas editar el archivo .env ahora? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            ${EDITOR:-nano} .env
        else
            print_warning "Recuerda editar .env antes de ejecutar la aplicación"
        fi
    else
        print_success "Archivo .env encontrado"
    fi
}

# Crear directorios necesarios
create_directories() {
    print_info "Creando directorios necesarios..."
    
    mkdir -p src/agents
    mkdir -p src/workflows
    mkdir -p src/tools
    mkdir -p logs
    mkdir -p init-db
    
    print_success "Directorios creados"
}

# Función para inicializar Mastra si no existe
init_mastra() {
    print_info "Verificando inicialización de Mastra..."
    
    # Verificar si node está disponible
    if command -v node &> /dev/null; then
        if [ ! -d "node_modules" ]; then
            print_info "Instalando dependencias de Mastra..."
            npm install || print_warning "No se pudieron instalar dependencias localmente. Docker las instalará."
            [ $? -eq 0 ] && print_success "Dependencias instaladas"
        fi
        
        if [ ! -d "src/mastra" ]; then
            print_warning "Directorio src/mastra no encontrado."
            print_info "Puedes inicializar Mastra después con: npx mastra init"
        fi
    else
        print_warning "Node.js no está disponible localmente."
        print_info "No hay problema, Docker instalará todo lo necesario."
        print_info "Si quieres desarrollo local, instala Node.js 20+ desde https://nodejs.org"
    fi
}

# Construir imágenes Docker
build_images() {
    print_info "Construyendo imágenes Docker..."
    docker compose build
    print_success "Imágenes construidas exitosamente"
}

# Mostrar ayuda
show_help() {
    cat << EOF
🎯 Script de Inicialización de Mastra Docker

Uso: $0 [OPCIÓN]

Opciones:
  -h, --help        Mostrar esta ayuda
  -d, --dev         Iniciar en modo desarrollo con hot-reload
  -f, --full        Iniciar todos los servicios (incluye Redis, PgAdmin)
  -b, --build       Forzar rebuild de las imágenes
  -c, --clean       Limpiar todo y empezar de cero
  --no-build        Iniciar sin reconstruir imágenes

Ejemplos:
  $0                # Inicio normal (producción)
  $0 --dev          # Modo desarrollo
  $0 --full         # Todos los servicios
  $0 --clean        # Limpiar y reiniciar

EOF
}

# Parsear argumentos
MODE="production"
BUILD=true
CLEAN=false
PROFILE=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--dev)
            MODE="development"
            PROFILE="--profile dev"
            shift
            ;;
        -f|--full)
            PROFILE="--profile full"
            shift
            ;;
        -b|--build)
            BUILD=true
            shift
            ;;
        --no-build)
            BUILD=false
            shift
            ;;
        -c|--clean)
            CLEAN=true
            shift
            ;;
        *)
            print_error "Opción desconocida: $1"
            show_help
            exit 1
            ;;
    esac
done

# Ejecutar verificaciones
check_docker
check_docker_compose

# Limpiar si se solicita
if [ "$CLEAN" = true ]; then
    print_warning "Limpiando entorno Docker..."
    docker compose down -v
    docker system prune -f
    rm -rf node_modules .mastra
    print_success "Entorno limpiado"
fi

# Preparar entorno
setup_env
create_directories

# Construir imágenes si es necesario
if [ "$BUILD" = true ]; then
    build_images
fi

# Inicializar Mastra localmente (para generar archivos necesarios)
init_mastra

# Iniciar servicios
print_info "Iniciando servicios Docker..."
echo ""

if [ "$MODE" = "development" ]; then
    print_info "🔥 Modo desarrollo activado (con hot-reload)"
    docker compose $PROFILE up
else
    print_info "🚀 Modo producción"
    docker compose $PROFILE up -d
    
    echo ""
    print_success "Servicios iniciados correctamente"
    echo ""
    print_info "📊 Estado de los servicios:"
    docker compose ps
    echo ""
    print_info "Para ver los logs:"
    echo "  docker compose logs -f mastra"
    echo ""
    print_info "Para detener los servicios:"
    echo "  docker compose down"
fi

echo ""
print_success "✨ Entorno Mastra listo!"
print_info "Accede a tu aplicación en: http://localhost:4111"

if [[ $PROFILE == *"dev"* ]] || [[ $PROFILE == *"full"* ]]; then
    print_info "PgAdmin disponible en: http://localhost:5050"
fi

echo ""
