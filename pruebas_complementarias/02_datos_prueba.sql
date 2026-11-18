-- ============================================
-- TFI - DATOS DE EJEMPLO (INSERCIONES VALIDAS)
-- Ejecutar luego de 02_catalogos.sql y 02_triggers.sql.
-- Este archivo deja 2 pacientes y 2 medicos de prueba.
-- ============================================
USE gestion_hospitalaria;

INSERT INTO pacientes
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre, telefono, direccion)
SELECT 'Juan', 'Perez', '34567890', '1998-05-15',
       'A_POSITIVO', '1123456789', 'Calle 123'
WHERE NOT EXISTS (SELECT 1 FROM pacientes WHERE dni = '34567890');

INSERT INTO pacientes
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre, telefono, direccion)
SELECT 'Maria', 'Gomez', '35678901', '2001-09-20',
       'O_NEGATIVO', '1198765432', 'Avenida 456'
WHERE NOT EXISTS (SELECT 1 FROM pacientes WHERE dni = '35678901');

INSERT INTO medicos
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre,
     numero_matricula, especialidad, id_departamento)
SELECT 'Juan', 'Perez', '48123456', '1985-04-12',
       'A_POSITIVO', 'MP-9876', 'CARDIOLOGIA', d.id_departamento
FROM departamentos d
WHERE d.nombre = 'Cardiologia'
  AND d.especialidad = 'CARDIOLOGIA'
  AND NOT EXISTS (SELECT 1 FROM medicos WHERE dni = '48123456');

INSERT INTO medicos
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre,
     numero_matricula, especialidad, id_departamento)
SELECT 'Maria', 'Lopez', '48123457', '1990-05-10',
       'O_POSITIVO', 'MP-9877', 'PEDIATRIA', d.id_departamento
FROM departamentos d
WHERE d.nombre = 'Pediatria'
  AND d.especialidad = 'PEDIATRIA'
  AND NOT EXISTS (SELECT 1 FROM medicos WHERE dni = '48123457');

SELECT COUNT(*) AS pacientes_de_ejemplo
FROM pacientes WHERE dni IN ('34567890','35678901');

SELECT COUNT(*) AS medicos_de_ejemplo
FROM medicos WHERE dni IN ('48123456','48123457');
