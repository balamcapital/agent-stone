#!/bin/bash

# Script de desarrollo rápido para Mastra
# Reinicia el contenedor de Mastra sin reconstruir todo

set -e

echo "🔄 Reiniciando Mastra en modo desarrollo..."

# Detener el contenedor actual
docker compose stop mastra

# Reconstruir solo si hay cambios en el código
echo "📦 Reconstruyendo contenedor..."
docker compose build mastra

# Reiniciar
echo "🚀 Iniciando Mastra..."
docker compose up -d mastra

# Mostrar logs
echo ""
echo "📋 Logs del contenedor:"
docker compose logs -f mastra
