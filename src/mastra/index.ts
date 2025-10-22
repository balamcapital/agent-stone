import { Mastra } from '@mastra/core';
import { generalAssistant } from '../agents/example-agent';

/**
 * Mastra Instance
 * 
 * Esta es la instancia principal de Mastra que configura tu aplicación.
 */
export const mastra = new Mastra({
  name: 'Agent Stone',
  agents: { generalAssistant }
});
