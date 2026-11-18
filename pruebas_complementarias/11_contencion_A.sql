USE gestion_hospitalaria;

-- Establecer el nivel de aislamiento
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Iniciar una transaccion
START TRANSACTION;

-- Modificar el Consultorio A
UPDATE prueba_contencion_indices
SET cupos = 4
WHERE codigo = 101;

-- Desactivar temporalmente el modo seguro
SET SQL_SAFE_UPDATES = 0;

-- Reintentar la actualización
UPDATE prueba_contencion_indices
SET cupos = 4
WHERE codigo = 101;

ROLLBACK;

-- ============================================
-- PRUEBA CON INDICE - CONEXION A


USE gestion_hospitalaria;

SET SQL_SAFE_UPDATES = 0;

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

UPDATE prueba_contencion_indices
SET cupos = 4
WHERE codigo = 101;


ROLLBACK;
SET SQL_SAFE_UPDATES = 1;