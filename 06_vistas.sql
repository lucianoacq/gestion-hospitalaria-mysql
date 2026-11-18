-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 4: SEGURIDAD Y PRIVACIDAD
-- ============================================

USE gestion_hospitalaria;



-- VISTA 1: CITAS OPERATIVAS
-- Sin datos personales de pacientes


CREATE OR REPLACE
SQL SECURITY DEFINER
VIEW vista_citas_operativas AS

SELECT
    c.id_cita,
    c.fecha_hora,
    c.estado,
    d.nombre AS departamento,
    s.numero AS sala
FROM citas c

INNER JOIN salas s
    ON c.id_sala = s.id_sala

INNER JOIN departamentos d
    ON s.id_departamento = d.id_departamento;



-- VISTA 2: RESUMEN POR DEPARTAMENTO
-- Informacion estadistica


CREATE OR REPLACE
SQL SECURITY DEFINER
VIEW vista_resumen_departamentos AS

SELECT
    d.nombre AS departamento,
    COUNT(c.id_cita) AS total_citas,
    SUM(
        CASE
            WHEN c.estado = 'PROGRAMADA'
            THEN 1
            ELSE 0
        END
    ) AS citas_programadas

FROM departamentos d

LEFT JOIN salas s
    ON d.id_departamento = s.id_departamento

LEFT JOIN citas c
    ON s.id_sala = c.id_sala

GROUP BY
    d.id_departamento,
    d.nombre;



-- VERIFICAR LAS DOS VISTAS


SELECT *
FROM vista_citas_operativas
LIMIT 10;

SELECT *
FROM vista_resumen_departamentos;
