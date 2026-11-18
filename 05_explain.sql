USE gestion_hospitalaria;

-- PRUEBA 1: CITAS POR FECHA, SIN USAR EL INDICE
EXPLAIN
SELECT id_cita, fecha_hora, estado
FROM citas IGNORE INDEX (idx_citas_fecha_hora)
WHERE fecha_hora >= '2027-02-01'
  AND fecha_hora < '2027-02-08'
ORDER BY fecha_hora;

-- PRUEBA 1: CITAS POR FECHA, CON INDICE DISPONIBLE
EXPLAIN
SELECT id_cita, fecha_hora, estado
FROM citas
WHERE fecha_hora >= '2027-02-01'
  AND fecha_hora < '2027-02-08'
ORDER BY fecha_hora;

-- PRUEBA 2: PACIENTES POR FECHA DE NACIMIENTO, SIN INDICE
EXPLAIN
SELECT id_paciente, nombre, apellido, fecha_nacimiento
FROM pacientes IGNORE INDEX (idx_pacientes_fecha_nacimiento)
WHERE fecha_nacimiento >= '1990-01-01'
  AND fecha_nacimiento < '1990-02-01'
ORDER BY fecha_nacimiento;

-- PRUEBA 2: PACIENTES POR FECHA DE NACIMIENTO, CON INDICE
EXPLAIN
SELECT id_paciente, nombre, apellido, fecha_nacimiento
FROM pacientes
WHERE fecha_nacimiento >= '1990-01-01'
  AND fecha_nacimiento < '1990-02-01'
ORDER BY fecha_nacimiento;

-- PRUEBA 3: CITAS POR COSTO, SIN INDICE
EXPLAIN
SELECT id_cita, costo
FROM citas IGNORE INDEX (idx_citas_costo)
WHERE costo = 52000;

-- PRUEBA 3: CITAS POR COSTO, CON INDICE
EXPLAIN
SELECT id_cita, costo
FROM citas
WHERE costo = 52000;
