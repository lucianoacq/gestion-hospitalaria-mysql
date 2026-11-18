-- ============================================
-- TRABAJO FINAL INTEGRADOR - BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- TRIGGERS DE INTEGRIDAD
-- ============================================

USE gestion_hospitalaria;

-- ELIMINAR TRIGGERS SI YA EXISTEN

DROP TRIGGER IF EXISTS validar_especialidad_medico_insert;
DROP TRIGGER IF EXISTS validar_especialidad_medico_update;
DROP TRIGGER IF EXISTS validar_especialidad_departamento_update;

DELIMITER $$

-- TRIGGER 1: VALIDAR INSERCION DE MEDICOS

CREATE TRIGGER validar_especialidad_medico_insert
BEFORE INSERT ON medicos
FOR EACH ROW
BEGIN

    IF NEW.id_departamento IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM departamentos
           WHERE id_departamento = NEW.id_departamento
           AND especialidad = NEW.especialidad
       )
    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'La especialidad del medico no coincide con la del departamento';

    END IF;

END$$


-- TRIGGER 2: VALIDAR MODIFICACION DE MEDICOS

CREATE TRIGGER validar_especialidad_medico_update
BEFORE UPDATE ON medicos
FOR EACH ROW
BEGIN

    IF NEW.id_departamento IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM departamentos
           WHERE id_departamento = NEW.id_departamento
           AND especialidad = NEW.especialidad
       )
    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'La especialidad del medico no coincide con la del departamento';

    END IF;

END$$


-- TRIGGER 3: VALIDAR MODIFICACION
-- DE ESPECIALIDAD DE DEPARTAMENTOS

CREATE TRIGGER validar_especialidad_departamento_update
BEFORE UPDATE ON departamentos
FOR EACH ROW
BEGIN

    IF NEW.especialidad <> OLD.especialidad
       AND EXISTS (
           SELECT 1
           FROM medicos
           WHERE id_departamento = OLD.id_departamento
           AND especialidad <> NEW.especialidad
       )
    THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'No se puede cambiar la especialidad: existen medicos incompatibles';

    END IF;

END$$

DELIMITER ;
