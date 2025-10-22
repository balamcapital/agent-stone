# 🎯 Próximos Pasos - Agent Stone

¡Felicidades! Has configurado exitosamente tu entorno Docker para Mastra. Aquí te guío sobre qué hacer a continuación.

---

## 📝 Paso 1: Configurar API Keys

Antes de comenzar, necesitas al menos una API key de un proveedor LLM:

### Opción A: OpenAI (Recomendado para empezar)
1. Ve a https://platform.openai.com/api-keys
2. Crea una nueva API key
3. Agrégala a `.env`:
```env
OPENAI_API_KEY=sk-proj-xxxxx...
```

### Opción B: Google Gemini (Gratis sin tarjeta)
1. Ve a https://aistudio.google.com/app/api-keys
2. Crea una API key
3. Agrégala a `.env`:
```env
GOOGLE_GENERATIVE_AI_API_KEY=xxxxx...
```

### Opción C: Anthropic Claude
1. Ve a https://console.anthropic.com/
2. Crea una API key
3. Agrégala a `.env`:
```env
ANTHROPIC_API_KEY=sk-ant-xxxxx...
```

---

## 🚀 Paso 2: Inicializar Mastra

### Opción A: Instalación Local (Recomendado)

```bash
# Instalar dependencias
npm install

# Inicializar Mastra
npx mastra init
```

Durante la inicialización, selecciona:
- ✅ **Agents** - Para crear agentes AI
- ✅ **Workflows** - Para orquestación
- ✅ **Scorers** - Para evaluaciones (opcional)
- ✅ **Add examples** - Para ver código de ejemplo

### Opción B: Usar Docker directamente

```bash
# Iniciar el entorno
./scripts/init.sh

# El entorno estará listo en http://localhost:4111
```

---

## 🎨 Paso 3: Crear tu Primer Agente

### Agente Simple

Crea el archivo `src/agents/alan-stone.ts`:

```typescript
import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';

export const alanStone = new Agent({
  name: 'Alan Stone',
  instructions: `
    You are Alan Stone, an expert AI agent specialized in helping 
    developers learn about AI and building intelligent applications.
    
    You are:
    - Knowledgeable about AI, ML, and LLMs
    - Patient and clear in explanations
    - Practical and focused on real-world applications
    - Encouraging and supportive
  `,
  model: openai('gpt-4o-mini'),
});
```

### Usar el Agente

Actualiza `src/index.ts`:

```typescript
import { mastra } from '../mastra.config';
import { alanStone } from './agents/alan-stone';

// Exportar el agente
export { alanStone };

// Ejemplo de uso
async function main() {
  const response = await alanStone.generate(
    'What are the key concepts I should learn about AI agents?'
  );
  
  console.log('Alan Stone says:', response.text);
}

// Ejecutar si es el archivo principal
if (import.meta.url === `file://${process.argv[1]}`) {
  main().catch(console.error);
}
```

---

## 🔥 Paso 4: Ejecutar en Modo Desarrollo

```bash
# Opción A: Desarrollo local
npm run dev

# Opción B: Docker con hot-reload
./scripts/init.sh --dev

# Verás los logs en tiempo real
```

Ahora cuando edites archivos en `src/`, los cambios se reflejan automáticamente!

---

## 🧪 Paso 5: Probar tu Agente

### Desde el código

```typescript
import { alanStone } from './agents/alan-stone';

const response = await alanStone.generate('Explain neural networks simply');
console.log(response.text);
```

### Usando el Playground de Mastra

```bash
# Iniciar el playground
npx mastra dev

# Abre http://localhost:4111/playground
```

---

## 🎓 Paso 6: Aprender Más

### Tutoriales Recomendados

1. **Primeros Pasos**
   - [Building Your First Agent](https://mastra.ai/course)
   - [Understanding Workflows](https://mastra.ai/docs/workflows/overview)

2. **Características Avanzadas**
   - [Memory & Context](https://mastra.ai/docs/memory/overview)
   - [RAG Implementation](https://mastra.ai/docs/rag/overview)
   - [Multi-Agent Networks](https://mastra.ai/docs/agents/networks)

3. **Ejemplos Prácticos**
   - [NotebookLM Clone](https://mastra.ai/blog/notebooklm-clone-with-agent-orchestration)
   - [Travel Planning Agent](https://mastra.ai/blog/travel-ai)
   - [Music Generation System](https://github.com/mastra-ai/ai-beat-lab)

### Recursos de Aprendizaje

📚 **Documentación**: https://mastra.ai/docs
🎥 **Videos**: https://youtube.com/@mastra-ai
💬 **Discord**: https://discord.gg/BTYqqHKUrf
📝 **Blog**: https://mastra.ai/blog

---

## 🛠️ Paso 7: Construir Algo Real

### Ideas de Proyectos

1. **Asistente de Código**
   - Agent que ayuda con debugging
   - Genera tests automáticamente
   - Explica código complejo

2. **Analizador de Documentos**
   - RAG sobre tus documentos
   - Responde preguntas específicas
   - Genera resúmenes

3. **Workflow de Contenido**
   - Genera ideas de contenido
   - Escribe borradores
   - Optimiza para SEO

4. **Soporte al Cliente**
   - Responde preguntas frecuentes
   - Escala tickets complejos
   - Mantiene historial de conversaciones

5. **Análisis de Datos**
   - Procesa datasets
   - Genera insights
   - Crea visualizaciones

---

## 🚢 Paso 8: Preparar para Producción

### Optimizar tu Build

```bash
# Build optimizado
docker compose build mastra

# Verificar tamaño
docker images | grep agent-stone
```

### Variables de Entorno

Asegúrate de configurar en producción:

```env
NODE_ENV=production
MASTRA_LOG_LEVEL=warn
DATABASE_URL=postgresql://...
# Tus API keys reales
```

### Deploy

El entorno está listo para:
- ✅ AWS ECS/Fargate
- ✅ Google Cloud Run
- ✅ DigitalOcean App Platform
- ✅ Railway/Fly.io
- ✅ Kubernetes

---

## 📊 Monitoreo y Debugging

### Ver Logs

```bash
# Logs de la aplicación
docker compose logs -f mastra

# Logs de la base de datos
docker compose logs -f postgres

# Todos los logs
docker compose logs -f
```

### Acceder a PgAdmin (modo dev)

1. Abre http://localhost:5050
2. Login:
   - Email: `admin@mastra.local`
   - Password: `admin`
3. Conecta a PostgreSQL:
   - Host: `postgres`
   - Port: `5432`
   - Database: `mastra`
   - User: `postgres`
   - Password: `postgres`

### Debugging

En modo desarrollo, el debugger está habilitado:

```bash
# Iniciar con debugging
./scripts/init.sh --dev

# Conectar debugger en puerto 9229
# VS Code: Adjuntar a proceso Node
```

---

## 🎯 Checklist de Setup Completo

- [ ] API Key configurada en `.env`
- [ ] Dependencias instaladas (`npm install`)
- [ ] Mastra inicializado (`npx mastra init`)
- [ ] Primer agente creado
- [ ] Docker funcionando (`docker compose ps`)
- [ ] Logs visibles (`docker compose logs -f`)
- [ ] Playground accesible (http://localhost:4111)
- [ ] Base de datos conectada
- [ ] Git configurado (`.env` en `.gitignore`)

---

## 🆘 ¿Necesitas Ayuda?

### Problemas Comunes

**Error: Docker no está corriendo**
```bash
# Inicia Docker Desktop
open -a Docker
```

**Error: Puerto 4111 en uso**
```bash
# Cambiar puerto en .env
MASTRA_PORT=4112
```

**Error: No se encuentra el módulo**
```bash
# Reinstalar dependencias
rm -rf node_modules
npm install
```

### Recursos de Soporte

1. **Documentación**: [README.md](README.md)
2. **Solución de Problemas**: Ver sección en README
3. **Discord de Mastra**: https://discord.gg/BTYqqHKUrf
4. **GitHub Issues**: https://github.com/mastra-ai/mastra/issues

---

## 🎉 ¡Estás Listo!

Tu entorno Docker está completamente configurado. Ahora puedes:

1. ✅ Desarrollar agentes AI
2. ✅ Crear workflows complejos
3. ✅ Implementar RAG
4. ✅ Desplegar en producción
5. ✅ Escalar tu aplicación

**Comienza con:**
```bash
./scripts/init.sh --dev
```

**¡A construir cosas increíbles! 🚀**

---

## 📚 Siguientes Lecturas

1. [Arquitectura de Agentes](https://mastra.ai/docs/agents/overview)
2. [Best Practices](https://mastra.ai/book)
3. [Templates Disponibles](https://mastra.ai/templates)
4. [Comunidad Showcase](https://mastra.ai/showcase)

---

**Alan Stone** 🎯  
_Tu compañero en el viaje de aprendizaje de AI_
