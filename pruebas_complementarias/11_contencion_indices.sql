-- ============================================
-- TFI BASE DE DATOS I
-- PRUEBA DE CONTENCION CON Y SIN INDICES
-- ============================================

USE gestion_hospitalaria;

-- Eliminar solamente la tabla auxiliar de ensayo
DROP TABLE IF EXISTS prueba_contencion_indices;

-- Crear tabla sin indice sobre codigo
CREATE TABLE prueba_contencion_indices (
    id INT PRIMARY KEY,
    codigo INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    cupos INT NOT NULL
) ENGINE = InnoDB;

-- Insertar tres recursos ficticios
INSERT INTO prueba_contencion_indices
    (id, codigo, nombre, cupos)
VALUES
    (1, 101, 'Consultorio A', 5),
    (2, 202, 'Consultorio B', 5),
    (3, 303, 'Consultorio C', 5);

-- Verificar registros
SELECT *
FROM prueba_contencion_indices;

-- Verificar los indices existentes
SHOW INDEX FROM prueba_contencion_indices;


-- ============================================
-- PRUEBA CON INDICE


SELECT *
FROM prueba_contencion_indices;

CREATE UNIQUE INDEX idx_codigo
ON prueba_contencion_indices (codigo);

SHOW INDEX FROM prueba_contencion_indices;


SELECT *
FROM prueba_contencion_indices;