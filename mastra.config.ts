import { Mastra } from '@mastra/core';

export const mastra = new Mastra({
  name: 'Agent Stone',
  
  // Configuración de logs
  logger: {
    name: 'Agent Stone',
    level: process.env.MASTRA_LOG_LEVEL || 'info',
  },
  
  // Telemetría deshabilitada por defecto
  telemetry: {
    enabled: process.env.MASTRA_TELEMETRY_ENABLED === 'true',
  },
  
  // Observabilidad
  observability: {
    // Habilitar exportador por defecto para AI tracing
    default: { 
      enabled: true 
    },
  },
  
  // Configuración de servidor
  server: {
    port: parseInt(process.env.PORT || '4111'),
    host: process.env.HOST || '0.0.0.0',
  },
});
