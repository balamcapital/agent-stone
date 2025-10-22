#!/bin/bash

# Script de backup de base de datos

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/mastra_backup_${TIMESTAMP}.sql"

echo "💾 Creando backup de la base de datos..."

# Crear directorio de backups si no existe
mkdir -p $BACKUP_DIR

# Realizar backup
docker compose exec -T postgres pg_dump -U postgres mastra > $BACKUP_FILE

echo "✅ Backup creado: $BACKUP_FILE"

# Comprimir backup
gzip $BACKUP_FILE
echo "📦 Backup comprimido: ${BACKUP_FILE}.gz"

# Limpiar backups antiguos (mantener últimos 7 días)
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete
echo "🧹 Backups antiguos eliminados"
