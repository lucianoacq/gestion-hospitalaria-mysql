-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 3: CONSULTAS SQL
-- ============================================

USE gestion_hospitalaria;



-- CONSULTA 1: JOIN
-- Mostrar citas con paciente, medico y sala


SELECT
    c.id_cita,
    CONCAT(p.nombre, ' ', p.apellido) AS paciente,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    d.nombre AS departamento,
    s.numero AS sala,
    c.fecha_hora,
    c.costo
FROM citas c
INNER JOIN pacientes p
    ON c.id_paciente = p.id_paciente
INNER JOIN medicos m
    ON c.id_medico = m.id_medico
INNER JOIN salas s
    ON c.id_sala = s.id_sala
INNER JOIN departamentos d
    ON s.id_departamento = d.id_departamento
ORDER BY c.fecha_hora
LIMIT 20;



-- CONSULTA 2: JOIN
-- Cantidad de citas por medico


SELECT
    m.id_medico,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    d.nombre AS departamento,
    COUNT(c.id_cita) AS total_citas
FROM medicos m
INNER JOIN departamentos d
    ON m.id_departamento = d.id_departamento
LEFT JOIN citas c
    ON m.id_medico = c.id_medico
GROUP BY
    m.id_medico,
    m.nombre,
    m.apellido,
    d.nombre
ORDER BY total_citas DESC
LIMIT 20;



-- CONSULTA 3: GROUP BY + HAVING
-- Departamentos con al menos 500 citas


SELECT
    d.nombre AS departamento,
    COUNT(c.id_cita) AS total_citas,
    SUM(c.costo) AS facturacion_potencial
FROM departamentos d
INNER JOIN salas s
    ON d.id_departamento = s.id_departamento
INNER JOIN citas c
    ON s.id_sala = c.id_sala
GROUP BY
    d.id_departamento,
    d.nombre
HAVING COUNT(c.id_cita) >= 500
ORDER BY total_citas DESC;



-- CONSULTA 4: SUBCONSULTA
-- Citas con costo superior al promedio


SELECT
    id_cita,
    id_paciente,
    fecha_hora,
    costo,
    estado
FROM citas
WHERE costo > (
    SELECT AVG(costo)
    FROM citas
)
ORDER BY costo DESC
LIMIT 20;



-- VISTA: CITAS DETALLADAS


CREATE OR REPLACE VIEW vista_citas_detalladas AS
SELECT
    c.id_cita,
    CONCAT(p.nombre, ' ', p.apellido) AS paciente,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    d.nombre AS departamento,
    s.numero AS sala,
    c.fecha_hora,
    c.costo,
    c.estado
FROM citas c
INNER JOIN pacientes p
    ON c.id_paciente = p.id_paciente
INNER JOIN medicos m
    ON c.id_medico = m.id_medico
INNER JOIN salas s
    ON c.id_sala = s.id_sala
INNER JOIN departamentos d
    ON s.id_departamento = d.id_departamento;

-- Verificar la vista

SELECT *
FROM vista_citas_detalladas
LIMIT 20;
