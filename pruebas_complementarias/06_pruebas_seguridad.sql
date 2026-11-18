-- ============================================
-- TFI ETAPA 4 - CONEXION Hospital - Solo lectura
-- Ejecutar las pruebas por bloques. La prueba 3 debe fallar.
-- ============================================
USE gestion_hospitalaria;

-- PRUEBA 1: acceso permitido a la vista operativa
SELECT * FROM vista_citas_operativas LIMIT 5;

-- PRUEBA 2: acceso permitido a la vista estadistica
SELECT * FROM vista_resumen_departamentos;

-- PRUEBA 3: debe dar error 1142 (acceso a tabla pacientes denegado)
-- EJECUTAR ESTA CONSULTA INDIVIDUALMENTE:
SELECT * FROM pacientes LIMIT 5;

-- PRUEBA 4: consulta parametrizada contra inyeccion SQL.
-- Ejecutar este bloque despues de la prueba 3.
PREPARE consulta_segura FROM
'SELECT departamento, total_citas
 FROM vista_resumen_departamentos
 WHERE departamento = ?';

SET @departamento = 'Cardiologia';
EXECUTE consulta_segura USING @departamento;

-- El texto se trata como dato; no modifica la logica del WHERE.
SET @departamento = 'Cardiologia'' OR ''1''=''1';
EXECUTE consulta_segura USING @departamento;

DEALLOCATE PREPARE consulta_segura;
