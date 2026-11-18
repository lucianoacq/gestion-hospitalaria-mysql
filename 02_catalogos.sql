-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 2: CATALOGOS
-- ============================================

USE gestion_hospitalaria;


-- 1. CARGA DE DEPARTAMENTOS


INSERT INTO departamentos (nombre, especialidad)
SELECT c.nombre, c.especialidad
FROM (
    SELECT 'Cardiologia' AS nombre, 'CARDIOLOGIA' AS especialidad
    UNION ALL SELECT 'Neurologia', 'NEUROLOGIA'
    UNION ALL SELECT 'Pediatria', 'PEDIATRIA'
    UNION ALL SELECT 'Traumatologia', 'TRAUMATOLOGIA'
    UNION ALL SELECT 'Ginecologia', 'GINECOLOGIA'
    UNION ALL SELECT 'Urologia', 'UROLOGIA'
    UNION ALL SELECT 'Oftalmologia', 'OFTALMOLOGIA'
    UNION ALL SELECT 'Dermatologia', 'DERMATOLOGIA'
    UNION ALL SELECT 'Psiquiatria', 'PSIQUIATRIA'
    UNION ALL SELECT 'Medicina General', 'MEDICINA_GENERAL'
    UNION ALL SELECT 'Cirugia General', 'CIRUGIA_GENERAL'
    UNION ALL SELECT 'Anestesiologia', 'ANESTESIOLOGIA'
) AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM departamentos d
    WHERE d.nombre = c.nombre
);


-- 2. CARGA DE SALAS
-- Dos consultorios por departamento


INSERT INTO salas (numero, tipo, id_departamento)
SELECT
    n.numero,
    'CONSULTORIO',
    d.id_departamento
FROM departamentos d
CROSS JOIN (
    SELECT '101' AS numero
    UNION ALL
    SELECT '102'
) AS n
WHERE NOT EXISTS (
    SELECT 1
    FROM salas s
    WHERE s.id_departamento = d.id_departamento
      AND s.numero = n.numero
);


-- 3. VERIFICACIONES

SELECT COUNT(*) AS total_departamentos
FROM departamentos;

SELECT COUNT(*) AS total_salas
FROM salas;

SELECT
    d.nombre AS departamento,
    d.especialidad,
    COUNT(s.id_sala) AS cantidad_salas
FROM departamentos d
LEFT JOIN salas s
    ON d.id_departamento = s.id_departamento
GROUP BY
    d.id_departamento,
    d.nombre,
    d.especialidad
ORDER BY d.nombre;
