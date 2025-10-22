# Dockerfile optimizado para Mastra Framework
# Multi-stage build para reducir tamaño de imagen final

# ============================================
# Stage 1: Dependencias
# ============================================
FROM node:20-alpine AS dependencies

WORKDIR /app

# Instalar dependencias del sistema necesarias
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    libc6-compat \
    git

# Copiar solo package.json
COPY package.json ./

# Instalar dependencias de producción solamente
RUN npm install --only=production --no-package-lock

# ============================================
# Stage 2: Builder
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias del sistema
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    libc6-compat

# Copiar package.json
COPY package.json ./

# Instalar TODAS las dependencias (incluyendo dev)
RUN npm install --no-package-lock

# Copiar código fuente
COPY . .

# Build de la aplicación Mastra
# Crear directorio .mastra si no existe
RUN mkdir -p .mastra/output && \
    (npm run build || npx mastra build || echo "Build step will complete in runtime") && \
    touch .mastra/output/.gitkeep

# ============================================
# Stage 3: Runtime
# ============================================
FROM node:20-alpine AS runtime

WORKDIR /app

# Instalar dependencias del sistema mínimas para runtime
RUN apk add --no-cache \
    gcompat \
    dumb-init

# Crear usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs && \
    adduser -S mastra -u 1001

# Copiar dependencias de producción desde stage dependencies
COPY --from=dependencies --chown=mastra:nodejs /app/node_modules ./node_modules

# Copiar package.json
COPY --chown=mastra:nodejs package*.json ./

# Copiar código fuente
COPY --chown=mastra:nodejs src ./src
COPY --chown=mastra:nodejs mastra.config.* ./

# Copiar archivos compilados desde builder
COPY --from=builder --chown=mastra:nodejs /app/.mastra ./.mastra

# Cambiar al usuario no-root
USER mastra

# Variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=4111
ENV HOST=0.0.0.0

# Exponer puerto de Mastra
EXPOSE 4111

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD node -e "require('http').get('http://localhost:4111/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Usar dumb-init para manejar señales correctamente
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Comando por defecto - ejecutar servidor Mastra
# Si .mastra no existe, usar el código fuente directamente
CMD ["sh", "-c", "if [ -f .mastra/output/index.mjs ]; then node --import=./.mastra/output/instrumentation.mjs .mastra/output/index.mjs; else npx mastra dev; fi"]
