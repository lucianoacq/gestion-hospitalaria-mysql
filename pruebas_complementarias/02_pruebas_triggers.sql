-- ============================================
-- TFI - PRUEBAS DE TRIGGERS
-- EJECUTAR CADA PRUEBA INVALIDA POR SEPARADO.
-- Requiere 02_catalogos.sql, 02_triggers.sql y 02_datos_prueba.sql.
-- No se modifican los datos cuando los triggers rechazan las operaciones.
-- ============================================
USE gestion_hospitalaria;

-- PRUEBA 1: MEDICOS BIEN ASIGNADOS (CONSULTA DE CONTROL)
SELECT m.nombre, m.apellido, m.especialidad,
       d.nombre AS departamento, d.especialidad AS especialidad_departamento
FROM medicos m
INNER JOIN departamentos d ON d.id_departamento = m.id_departamento
WHERE m.dni IN ('48123456','48123457');

-- PRUEBA 2: INSERT INVALIDO (error 1644 por especialidad incompatible)
-- DNI y matricula son distintos de los datos de ejemplo, para NO activar UNIQUE.
INSERT INTO medicos
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre,
     numero_matricula, especialidad, id_departamento)
SELECT 'Medico', 'Invalido', '48123458', '1990-05-10',
       'O_POSITIVO', 'MP-9878', 'PEDIATRIA', d.id_departamento
FROM departamentos d
WHERE d.nombre = 'Cardiologia';

-- PRUEBA 3: UPDATE INVALIDO DE MEDICO (error 1644)
UPDATE medicos
SET especialidad = 'PEDIATRIA'
WHERE dni = '48123456';

-- PRUEBA 4: UPDATE INVALIDO DE DEPARTAMENTO (error 1644)
UPDATE departamentos
SET especialidad = 'PEDIATRIA'
WHERE nombre = 'Cardiologia';
