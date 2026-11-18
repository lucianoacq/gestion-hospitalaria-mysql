-- ============================================
-- TFI BASE DE DATOS I
-- ETAPA 5: REINTENTO AUTOMATICO
-- ============================================

USE gestion_hospitalaria;

-- Registro de errores 1213
CREATE TABLE IF NOT EXISTS registro_errores_deadlock (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    intento INT NOT NULL,
    codigo_error INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE = InnoDB;

DROP PROCEDURE IF EXISTS actualizar_cupos_con_reintento;

DELIMITER $$

CREATE PROCEDURE actualizar_cupos_con_reintento(
    IN p_simular_error BOOLEAN
)
BEGIN
    DECLARE v_intento INT DEFAULT 0;
    DECLARE v_deadlock BOOLEAN DEFAULT FALSE;
    DECLARE v_exito BOOLEAN DEFAULT FALSE;
    DECLARE v_mensaje VARCHAR(255);

    -- Capturar errores de deadlock
    DECLARE CONTINUE HANDLER FOR 1213
    BEGIN
        GET STACKED DIAGNOSTICS CONDITION 1
            v_mensaje = MESSAGE_TEXT;

        SET v_deadlock = TRUE;

        ROLLBACK;

        INSERT INTO registro_errores_deadlock (
            intento,
            codigo_error,
            descripcion
        )
        VALUES (
            v_intento,
            1213,
            v_mensaje
        );

        COMMIT;

        -- Backoff progresivo entre reintentos
        IF v_intento < 3 THEN
            DO SLEEP(v_intento * 0.25);
        END IF;

    END;

    -- Otros errores no se reintentan
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Un intento inicial y hasta dos reintentos
    reintentos: WHILE v_intento < 3
                  AND v_exito = FALSE DO

        SET v_intento = v_intento + 1;
        SET v_deadlock = FALSE;

        START TRANSACTION;

        UPDATE prueba_transacciones
        SET cupos_disponibles = 4
        WHERE id_recurso = 1;

        -- Simulacion controlada para verificar
        -- el mecanismo de reintentos
        IF p_simular_error = TRUE
           AND v_intento <= 2
           AND v_deadlock = FALSE THEN

            SIGNAL SQLSTATE '40001'
            SET MYSQL_ERRNO = 1213,
                MESSAGE_TEXT =
                'Error 1213 simulado para probar reintentos';

        END IF;

        IF v_deadlock = FALSE THEN
            UPDATE prueba_transacciones
            SET cupos_disponibles = 3
            WHERE id_recurso = 2;
        END IF;

        IF v_deadlock = FALSE THEN
            COMMIT;
            SET v_exito = TRUE;
        END IF;

    END WHILE;

    IF v_exito = FALSE THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'No se pudo completar tras dos reintentos';
    END IF;

    SELECT
        'TRANSACCION EXITOSA' AS resultado,
        v_intento AS intentos_realizados;

END$$

DELIMITER ;



-- ============================================
-- PRUEBA DEL REINTENTO AUTOMATICO


CALL actualizar_cupos_con_reintento(TRUE);



-- ============================================
-- VERIFICAR ERRORES REGISTRADOS


SELECT
    intento,
    codigo_error,
    descripcion
FROM registro_errores_deadlock
ORDER BY id_registro DESC
LIMIT 2;


SET @inicio_prueba = NOW(6);

CALL actualizar_cupos_con_reintento(TRUE);

SELECT
    ROUND(
        TIMESTAMPDIFF(
            MICROSECOND,
            @inicio_prueba,
            NOW(6)
        ) / 1000, 2
    ) AS duracion_total_ms;