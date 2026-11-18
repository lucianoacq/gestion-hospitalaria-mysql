-- ============================================
-- TFI - PRUEBAS DE RESTRICCIONES: RESULTADOS ESPERADOS
-- EJECUTAR CADA INSERT POR SEPARADO. NO EJECUTAR TODO JUNTO.
-- Requiere haber ejecutado 02_datos_prueba.sql.
-- Las dos inserciones VALIDAS estan en 02_datos_prueba.sql.
-- Estos dos INSERT deben fallar intencionalmente.
-- ============================================
USE gestion_hospitalaria;

-- PRUEBA INVALIDA 1: DNI duplicado -> error 1062 (UNIQUE)
INSERT INTO pacientes
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre, telefono, direccion)
VALUES ('Otro', 'Paciente', '34567890', '2000-01-01',
        'A_POSITIVO', '1100000000', 'Calle Prueba');

-- PRUEBA INVALIDA 2: tipo de sangre no permitido -> error 3819 (CHECK)
INSERT INTO pacientes
    (nombre, apellido, dni, fecha_nacimiento, tipo_sangre, telefono, direccion)
VALUES ('Otro', 'Paciente', '36999999', '2000-01-01',
        'DESCONOCIDO', '1100000000', 'Calle Prueba');
