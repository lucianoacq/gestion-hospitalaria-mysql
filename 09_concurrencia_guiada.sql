-- ETAPA 5. CONCURRENCIA GUIADA (INSTRUCCIONES, NO SCRIPT DE EJECUCION AUTOMATICA)
-- Preparar la tabla auxiliar ejecutando 08_transacciones.sql.
-- Abrir DOS conexiones independientes de MySQL Workbench como administrador.
-- Ejecutar MANUALMENTE, paso a paso, los bloques señalados en:
--   pruebas_complementarias/07_transacciones_A.sql
--   pruebas_complementarias/07_transacciones_B.sql
-- Los scripts requieren alternar sentencias entre las conexiones A y B.
-- No ejecutar de una vez ambos archivos: se bloquearian o dejarian transacciones abiertas.
-- La prueba de deadlock real genera error esperado 1213 en la sesion elegida por InnoDB.
-- La recuperacion con reintentos y backoff se documenta en:
--   pruebas_complementarias/10_reintento_automatico.sql
USE gestion_hospitalaria;
SELECT * FROM prueba_transacciones ORDER BY id_recurso;
