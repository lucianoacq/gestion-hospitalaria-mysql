
-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 4: PROCEDIMIENTO ALMACENADO SEGURO
-- ============================================

USE gestion_hospitalaria;

-- Eliminar el procedimiento si ya existe
DROP PROCEDURE IF EXISTS buscar_departamento_seguro;

DELIMITER $$

-- Crear procedimiento con un parametro de entrada
CREATE PROCEDURE buscar_departamento_seguro(
    IN p_departamento VARCHAR(100)
)
SQL SECURITY DEFINER
READS SQL DATA
BEGIN

    SELECT
        departamento,
        total_citas,
        citas_programadas
    FROM vista_resumen_departamentos
    WHERE departamento = p_departamento;

END$$

DELIMITER ;

-- Permitir su ejecucion al usuario de solo lectura
GRANT EXECUTE
ON PROCEDURE gestion_hospitalaria.buscar_departamento_seguro
TO 'consulta_hospital'@'localhost';

-- ============================================
-- PRUEBA 1: CONSULTA NORMAL
-- ============================================

CALL buscar_departamento_seguro('Cardiologia');
