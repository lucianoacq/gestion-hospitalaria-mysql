USE gestion_hospitalaria;

-- Limitar la espera por bloqueos a 5 segundos
SET SESSION innodb_lock_wait_timeout = 5;

-- Desactivar Safe Update Mode
SET SQL_SAFE_UPDATES = 0;

-- Nivel de aislamiento
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

-- Intentar modificar otro consultorio
UPDATE prueba_contencion_indices
SET cupos = 4
WHERE codigo = 202;

ROLLBACK;


-- ============================================
-- PRUEBA CON INDICE - CONEXION B


USE gestion_hospitalaria;

SET SESSION innodb_lock_wait_timeout = 5;

SET SQL_SAFE_UPDATES = 0;

START TRANSACTION;

UPDATE prueba_contencion_indices
SET cupos = 4
WHERE codigo = 202;


ROLLBACK;
SET SQL_SAFE_UPDATES = 1;