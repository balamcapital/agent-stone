import { mastra } from '../mastra.config';

/**
 * Exporta la instancia de Mastra configurada
 * 
 * Esta es la instancia principal de tu aplicación Mastra.
 * Aquí puedes registrar tus agentes, workflows, y herramientas.
 */
export { mastra };

/**
 * Ejemplo: Exportar agentes
 * 
 * import { myAgent } from './agents/my-agent';
 * export { myAgent };
 */

/**
 * Ejemplo: Exportar workflows
 * 
 * import { myWorkflow } from './workflows/my-workflow';
 * export { myWorkflow };
 */

console.log('✅ Mastra initialized successfully');
console.log(`🚀 Server running on port ${process.env.PORT || 4111}`);
