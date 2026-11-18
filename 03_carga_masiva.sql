-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 2: CARGA MASIVA DE PACIENTES
-- ============================================

USE gestion_hospitalaria;

-- Permitir generar 12000 numeros consecutivos
SET SESSION cte_max_recursion_depth = 12050;



-- GENERAR 12000 PACIENTES FICTICIOS

INSERT INTO pacientes (
    nombre,
    apellido,
    dni,
    fecha_nacimiento,
    tipo_sangre,
    telefono,
    direccion
)

WITH RECURSIVE numeros AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numeros
    WHERE n < 12000
)

SELECT
    CONCAT('Paciente', n),
    'Simulado',
    CAST(60000000 + n AS CHAR),

    DATE_ADD(
        '1950-01-01',
        INTERVAL ((n * 37) % 24000) DAY
    ),

    CASE n % 8
        WHEN 0 THEN 'A_POSITIVO'
        WHEN 1 THEN 'A_NEGATIVO'
        WHEN 2 THEN 'B_POSITIVO'
        WHEN 3 THEN 'B_NEGATIVO'
        WHEN 4 THEN 'AB_POSITIVO'
        WHEN 5 THEN 'AB_NEGATIVO'
        WHEN 6 THEN 'O_POSITIVO'
        ELSE 'O_NEGATIVO'
    END,

    CONCAT('11', LPAD(n, 8, '0')),
    CONCAT('Calle Ficticia ', n)

FROM numeros

WHERE NOT EXISTS (
    SELECT 1
    FROM pacientes p
    WHERE p.dni = CAST(60000000 + n AS CHAR)
);



-- VERIFICACIONES

SELECT COUNT(*) AS total_pacientes
FROM pacientes;

SELECT COUNT(*) AS pacientes_generados
FROM pacientes
WHERE CAST(dni AS UNSIGNED)
BETWEEN 60000001 AND 60012000;



-- GENERAR 240 MEDICOS FICTICIOS
-- 20 MEDICOS POR DEPARTAMENTO


INSERT INTO medicos (
    nombre,
    apellido,
    dni,
    fecha_nacimiento,
    tipo_sangre,
    numero_matricula,
    especialidad,
    id_departamento
)

WITH RECURSIVE numeros AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numeros
    WHERE n < 20
)

SELECT
    CONCAT('Medico', n),
    'Simulado',

    CAST(70000000 + d.id_departamento * 1000 + n AS CHAR),

    DATE_ADD(
        '1970-01-01',
        INTERVAL ((n * 421 + d.id_departamento * 199) % 11000) DAY
    ),

    CASE n % 8
        WHEN 0 THEN 'A_POSITIVO'
        WHEN 1 THEN 'A_NEGATIVO'
        WHEN 2 THEN 'B_POSITIVO'
        WHEN 3 THEN 'B_NEGATIVO'
        WHEN 4 THEN 'AB_POSITIVO'
        WHEN 5 THEN 'AB_NEGATIVO'
        WHEN 6 THEN 'O_POSITIVO'
        ELSE 'O_NEGATIVO'
    END,

    CONCAT(
        'MP-',
        LPAD(d.id_departamento * 100 + n, 6, '0')
    ),

    d.especialidad,
    d.id_departamento

FROM departamentos d
CROSS JOIN numeros

WHERE NOT EXISTS (
    SELECT 1
    FROM medicos m
    WHERE m.dni = CAST(
        70000000 + d.id_departamento * 1000 + n AS CHAR
    )
);



-- VERIFICAR MEDICOS GENERADOS

SELECT COUNT(*) AS total_medicos
FROM medicos;

SELECT
    d.nombre AS departamento,
    d.especialidad,
    COUNT(m.id_medico) AS cantidad_medicos
FROM departamentos d
LEFT JOIN medicos m
    ON m.id_departamento = d.id_departamento
GROUP BY
    d.id_departamento,
    d.nombre,
    d.especialidad
ORDER BY d.nombre;



-- GENERAR 12000 CITAS MEDICAS


USE gestion_hospitalaria;

INSERT INTO citas (
    id_paciente,
    id_medico,
    id_sala,
    fecha_hora,
    costo,
    estado,
    observaciones
)

WITH
-- Pacientes generados en la carga masiva
pacientes_base AS (
    SELECT
        id_paciente,
        CAST(dni AS UNSIGNED) - 60000001 AS n
    FROM pacientes
    WHERE dni BETWEEN '60000001' AND '60012000'
),

-- Numeramos las 24 salas del hospital
salas_base AS (
    SELECT
        id_sala,
        id_departamento,
        ROW_NUMBER() OVER (
            ORDER BY id_departamento, numero
        ) - 1 AS posicion
    FROM salas
    WHERE numero IN ('101', '102')
      AND tipo = 'CONSULTORIO'
),

-- Numeramos los medicos de cada departamento
medicos_base AS (
    SELECT
        id_medico,
        id_departamento,
        ROW_NUMBER() OVER (
            PARTITION BY id_departamento
            ORDER BY id_medico
        ) AS posicion
    FROM medicos
),

-- Asignamos a cada paciente una sala y un horario
turnos_base AS (
    SELECT
        p.id_paciente,
        p.n,
        s.id_sala,
        s.id_departamento,
        s.posicion AS posicion_sala,

        DATE_ADD(
            DATE_ADD(
                '2027-01-01 08:00:00',
                INTERVAL FLOOR(p.n / 96) DAY
            ),
            INTERVAL (
                2 * FLOOR(MOD(p.n, 96) / 24)
            ) HOUR
        ) AS fecha_turno

    FROM pacientes_base p
    INNER JOIN salas_base s
        ON s.posicion = MOD(p.n, 24)
)

SELECT
    t.id_paciente,
    m.id_medico,
    t.id_sala,
    t.fecha_turno,

    25000 + MOD(t.n, 10) * 3000,

    'PROGRAMADA',
    'Carga masiva TFI'

FROM turnos_base t

INNER JOIN medicos_base m
    ON m.id_departamento = t.id_departamento
    AND m.posicion = (
        MOD(
            FLOOR(t.n / 24) * 2
            + MOD(t.posicion_sala, 2),
            20
        ) + 1
    )

WHERE NOT EXISTS (
    SELECT 1
    FROM citas c
    WHERE c.id_paciente = t.id_paciente
      AND c.fecha_hora = t.fecha_turno
);



-- 7. VERIFICAR CARGA MASIVA


SELECT COUNT(*) AS total_citas
FROM citas;

SELECT COUNT(*) AS citas_generadas
FROM citas
WHERE observaciones = 'Carga masiva TFI';



-- MOSTRAR 10 CITAS CON SUS RELACIONES

SELECT
    c.id_cita,
    p.nombre AS paciente,
    m.nombre AS medico,
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
    ON s.id_departamento = d.id_departamento

ORDER BY c.id_cita
LIMIT 10;

WITH turnos_ordenados AS (
    SELECT
        id_medico,
        fecha_hora,
        LAG(fecha_hora) OVER (
            PARTITION BY id_medico
            ORDER BY fecha_hora, id_cita
        ) AS turno_anterior
    FROM citas
    WHERE estado <> 'CANCELADA'
)
SELECT COUNT(*) AS conflictos_medicos
FROM turnos_ordenados
WHERE turno_anterior IS NOT NULL
  AND TIMESTAMPDIFF(
      MINUTE, turno_anterior, fecha_hora
  ) < 120;
  
  WITH turnos_ordenados AS (
    SELECT
        id_sala,
        fecha_hora,
        LAG(fecha_hora) OVER (
            PARTITION BY id_sala
            ORDER BY fecha_hora, id_cita
        ) AS turno_anterior
    FROM citas
    WHERE estado <> 'CANCELADA'
)
SELECT COUNT(*) AS conflictos_salas
FROM turnos_ordenados
WHERE turno_anterior IS NOT NULL
  AND TIMESTAMPDIFF(
      MINUTE, turno_anterior, fecha_hora
  ) < 120;
  
  SELECT COUNT(*) AS citas_departamento_incorrecto
FROM citas c
INNER JOIN medicos m
    ON c.id_medico = m.id_medico
INNER JOIN salas s
    ON c.id_sala = s.id_sala
INNER JOIN departamentos d
    ON s.id_departamento = d.id_departamento
WHERE m.id_departamento IS NULL
   OR m.id_departamento <> s.id_departamento
   OR m.especialidad <> d.especialidad;
