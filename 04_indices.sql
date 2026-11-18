-- ============================================
-- TFI ETAPA 3: TRES COMPARACIONES EXPLAIN
-- Comparacion reproducible: IGNORE INDEX vs. uso normal.
-- 'rows' representa FILAS ESTIMADAS por MySQL, NO tiempo medido.
-- ============================================
USE gestion_hospitalaria;

-- Asegurar que los 3 indices existan, sin error si ya fueron creados.
DROP PROCEDURE IF EXISTS tfi_asegurar_indices;
DELIMITER $$
CREATE PROCEDURE tfi_asegurar_indices()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'citas'
          AND index_name = 'idx_citas_fecha_hora'
    ) THEN
        CREATE INDEX idx_citas_fecha_hora ON citas (fecha_hora);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'pacientes'
          AND index_name = 'idx_pacientes_fecha_nacimiento'
    ) THEN
        CREATE INDEX idx_pacientes_fecha_nacimiento
            ON pacientes (fecha_nacimiento);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'citas'
          AND index_name = 'idx_citas_costo'
    ) THEN
        CREATE INDEX idx_citas_costo ON citas (costo);
    END IF;
END$$
DELIMITER ;
CALL tfi_asegurar_indices();
DROP PROCEDURE IF EXISTS tfi_asegurar_indices;


-- Consultas EXPLAIN separadas en 05_explain.sql.
