USE gestion_hospitalaria;

EXPLAIN ANALYZE
SELECT
    id_paciente,
    nombre,
    apellido,
    fecha_nacimiento
FROM pacientes IGNORE INDEX (idx_pacientes_fecha_nacimiento)
WHERE fecha_nacimiento >= '1990-01-01'
  AND fecha_nacimiento < '1990-02-01'
ORDER BY fecha_nacimiento;



-- ============================================
-- MEDICION CON INDICE
-- ============================================

EXPLAIN ANALYZE
SELECT
    id_paciente,
    nombre,
    apellido,
    fecha_nacimiento
FROM pacientes
WHERE fecha_nacimiento >= '1990-01-01'
  AND fecha_nacimiento < '1990-02-01'
ORDER BY fecha_nacimiento;



-- ============================================
-- MEDICION JOIN SIN INDICE
-- ============================================

EXPLAIN ANALYZE
SELECT
    p.id_paciente,
    p.nombre,
    p.apellido,
    c.id_cita,
    c.fecha_hora
FROM pacientes p
IGNORE INDEX (idx_pacientes_fecha_nacimiento)
INNER JOIN citas c
    ON p.id_paciente = c.id_paciente
WHERE p.fecha_nacimiento >= '1990-01-01'
  AND p.fecha_nacimiento < '1990-02-01'
ORDER BY p.fecha_nacimiento, c.fecha_hora;



-- ============================================
-- MEDICION JOIN CON INDICE
-- ============================================

EXPLAIN ANALYZE
SELECT
    p.id_paciente,
    p.nombre,
    p.apellido,
    c.id_cita,
    c.fecha_hora
FROM pacientes p
INNER JOIN citas c
    ON p.id_paciente = c.id_paciente
WHERE p.fecha_nacimiento >= '1990-01-01'
  AND p.fecha_nacimiento < '1990-02-01'
ORDER BY p.fecha_nacimiento, c.fecha_hora;



-- ============================================
-- MEDICION POR IGUALDAD SIN INDICE
-- ============================================

EXPLAIN ANALYZE
SELECT
    id_cita,
    costo
FROM citas IGNORE INDEX (idx_citas_costo)
WHERE costo = 52000;



-- ============================================
-- MEDICION POR IGUALDAD CON INDICE
-- ============================================

EXPLAIN ANALYZE
SELECT
    id_cita,
    costo
FROM citas
WHERE costo = 52000;