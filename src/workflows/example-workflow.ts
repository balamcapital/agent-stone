import { Workflow } from '@mastra/core';

/**
 * Workflow ejemplo - Procesamiento de datos simple
 * 
 * Este workflow demuestra cómo crear un flujo de trabajo básico.
 * Los workflows en Mastra permiten orquestar múltiples pasos y agentes.
 */
export const exampleWorkflow = new Workflow({
  name: 'example-workflow',
  
  // Define los pasos del workflow
  steps: {
    // Paso 1: Validación de entrada
    validate: {
      execute: async (context: any) => {
        console.log('Validating input...');
        return { valid: true, data: context.input };
      },
    },
    
    // Paso 2: Procesamiento
    process: {
      execute: async (context: any) => {
        console.log('Processing data...');
        return { processed: true, result: context.data };
      },
    },
    
    // Paso 3: Finalización
    finalize: {
      execute: async (context: any) => {
        console.log('Finalizing...');
        return { status: 'complete', output: context.result };
      },
    },
  },
  
  // Define el flujo de ejecución
  flow: [
    { step: 'validate', next: 'process' },
    { step: 'process', next: 'finalize' },
    { step: 'finalize' },
  ],
});

/**
 * Ejemplo de uso:
 * 
 * import { exampleWorkflow } from './workflows/example-workflow';
 * 
 * const result = await exampleWorkflow.execute({
 *   input: 'some data'
 * });
 * 
 * console.log(result);
 */
