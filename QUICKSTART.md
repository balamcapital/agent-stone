# Guía de Inicio Rápido - Mastra Docker

## 🎯 En 5 minutos

### Paso 1: Clonar y configurar

```bash
git clone <tu-repo>
cd agent-stone
cp .env.example .env
```

### Paso 2: Agregar API Key

Edita `.env` y agrega tu OpenAI API key:

```env
OPENAI_API_KEY=sk-your-key-here
```

### Paso 3: Iniciar

```bash
./scripts/init.sh
```

### Paso 4: Verificar

Abre http://localhost:4111

---

## 📖 Comandos Útiles

```bash
# Ver logs
docker compose logs -f mastra

# Reiniciar
docker compose restart mastra

# Detener todo
docker compose down

# Limpiar y reiniciar
./scripts/init.sh --clean
```

---

## 🔥 Modo Desarrollo

```bash
./scripts/init.sh --dev
```

Incluye:
- Hot reload
- PgAdmin en http://localhost:5050
- Debug port 9229

---

## 📚 Más información

Ver el [README.md](README.md) completo para detalles.
