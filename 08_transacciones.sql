-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 5: TRANSACCIONES Y CONCURRENCIA
-- ============================================

USE gestion_hospitalaria;

-- Tabla auxiliar para simular operaciones
-- concurrentes sin modificar las citas reales.

CREATE TABLE IF NOT EXISTS prueba_transacciones (
    id_recurso INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cupos_disponibles INT NOT NULL,

    CONSTRAINT chk_cupos_prueba
        CHECK (cupos_disponibles >= 0)
) ENGINE = InnoDB;

-- Cargar dos recursos ficticios

INSERT IGNORE INTO prueba_transacciones
    (id_recurso, nombre, cupos_disponibles)
VALUES
    (1, 'Consultorio A', 5),
    (2, 'Consultorio B', 5);

-- Restablecer ambos recursos para reproducir las pruebas.
-- ATENCION: modifica los cupos de esta tabla AUXILIAR.
UPDATE prueba_transacciones
SET cupos_disponibles = 5
WHERE id_recurso IN (1, 2);

-- Verificar los datos

SELECT *
FROM prueba_transacciones;
