-- Script de inicialización de base de datos para Mastra
-- Este script se ejecuta automáticamente al crear el contenedor de PostgreSQL

-- Crear extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Nota: La extensión vector (pgvector) requiere una imagen especial de PostgreSQL
-- Si necesitas pgvector para embeddings/RAG, usa: docker.io/pgvector/pgvector:pg16
-- Por ahora, la comentamos para que funcione con postgres:16-alpine estándar
-- CREATE EXTENSION IF NOT EXISTS "vector";

-- Crear esquemas
CREATE SCHEMA IF NOT EXISTS mastra;

-- Configurar búsqueda de esquemas
SET search_path TO mastra, public;

-- Logs
\echo 'Base de datos Mastra inicializada correctamente';
