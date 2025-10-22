import { Agent } from '@mastra/core';
import { openai } from '@ai-sdk/openai';

/**
 * Agente ejemplo - Asistente General
 * 
 * Este es un agente básico que puede responder preguntas generales.
 * Úsalo como plantilla para crear tus propios agentes.
 */
export const generalAssistant = new Agent({
  name: 'General Assistant',
  instructions: `
    You are a helpful and friendly AI assistant.
    You provide clear, accurate, and concise answers.
    You are polite and professional in your responses.
    If you don't know something, you admit it honestly.
  `,
  model: openai('gpt-4o-mini'),
});

/**
 * Ejemplo de uso:
 * 
 * import { generalAssistant } from './agents/example-agent';
 * 
 * const response = await generalAssistant.generate('What is AI?');
 * console.log(response.text);
 */
