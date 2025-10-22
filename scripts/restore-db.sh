#!/bin/bash

# Script de restauración de base de datos

set -e

if [ -z "$1" ]; then
    echo "❌ Error: Debes especificar el archivo de backup"
    echo "Uso: $0 <archivo_backup.sql.gz>"
    echo ""
    echo "Backups disponibles:"
    ls -lh ./backups/*.gz 2>/dev/null || echo "No hay backups disponibles"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Error: Archivo no encontrado: $BACKUP_FILE"
    exit 1
fi

echo "⚠️  Esto sobrescribirá la base de datos actual."
read -p "¿Estás seguro? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^yes$ ]]; then
    echo "❌ Operación cancelada"
    exit 1
fi

echo "🔄 Restaurando base de datos desde: $BACKUP_FILE"

# Descomprimir si es necesario
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "📦 Descomprimiendo backup..."
    gunzip -c $BACKUP_FILE | docker compose exec -T postgres psql -U postgres mastra
else
    docker compose exec -T postgres psql -U postgres mastra < $BACKUP_FILE
fi

echo "✅ Base de datos restaurada exitosamente"
