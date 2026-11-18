-- ============================================
-- TFI BASE DE DATOS I - GESTION HOSPITALARIA
-- ETAPA 1: ESQUEMA Y RESTRICCIONES
-- ============================================
-- SEGURO EN LA BASE EXISTENTE: CREATE TABLE IF NOT EXISTS.
-- AVISO: si una tabla ya existe, este archivo NO actualiza su estructura.
-- Para reconstruir desde cero, usar una base de pruebas vacia.
-- Los datos de ejemplo estan en 02_datos_prueba.sql.

CREATE DATABASE IF NOT EXISTS gestion_hospitalaria;
USE gestion_hospitalaria;

CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    especialidad VARCHAR(50) NOT NULL,
    CONSTRAINT chk_especialidad_departamento
        CHECK (especialidad IN (
            'CARDIOLOGIA', 'NEUROLOGIA', 'PEDIATRIA',
            'TRAUMATOLOGIA', 'GINECOLOGIA', 'UROLOGIA',
            'OFTALMOLOGIA', 'DERMATOLOGIA', 'PSIQUIATRIA',
            'MEDICINA_GENERAL', 'CIRUGIA_GENERAL', 'ANESTESIOLOGIA'
        ))
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(8) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    tipo_sangre VARCHAR(15) NOT NULL,
    telefono VARCHAR(30) NOT NULL,
    direccion VARCHAR(200) NOT NULL,
    CONSTRAINT chk_dni_paciente
        CHECK (dni REGEXP '^[0-9]{7,8}$'),
    CONSTRAINT chk_tipo_sangre
        CHECK (tipo_sangre IN (
            'A_POSITIVO', 'A_NEGATIVO', 'B_POSITIVO', 'B_NEGATIVO',
            'AB_POSITIVO', 'AB_NEGATIVO', 'O_POSITIVO', 'O_NEGATIVO'
        ))
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(8) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    tipo_sangre VARCHAR(15) NOT NULL,
    numero_matricula VARCHAR(9) NOT NULL UNIQUE,
    especialidad VARCHAR(50) NOT NULL,
    id_departamento INT,
    CONSTRAINT fk_medico_departamento
        FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    CONSTRAINT chk_dni_medico
        CHECK (dni REGEXP '^[0-9]{7,8}$'),
    CONSTRAINT chk_matricula
        CHECK (numero_matricula REGEXP '^MP-[0-9]{4,6}$'),
    CONSTRAINT chk_tipo_sangre_medico
        CHECK (tipo_sangre IN (
            'A_POSITIVO', 'A_NEGATIVO', 'B_POSITIVO', 'B_NEGATIVO',
            'AB_POSITIVO', 'AB_NEGATIVO', 'O_POSITIVO', 'O_NEGATIVO'
        )),
    CONSTRAINT chk_especialidad_medico
        CHECK (especialidad IN (
            'CARDIOLOGIA', 'NEUROLOGIA', 'PEDIATRIA',
            'TRAUMATOLOGIA', 'GINECOLOGIA', 'UROLOGIA',
            'OFTALMOLOGIA', 'DERMATOLOGIA', 'PSIQUIATRIA',
            'MEDICINA_GENERAL', 'CIRUGIA_GENERAL', 'ANESTESIOLOGIA'
        ))
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS salas (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_sala_departamento
        FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento),
    CONSTRAINT uq_sala_departamento
        UNIQUE (id_departamento, numero),
    CONSTRAINT chk_numero_sala
        CHECK (CHAR_LENGTH(TRIM(numero)) > 0),
    CONSTRAINT chk_tipo_sala
        CHECK (CHAR_LENGTH(TRIM(tipo)) > 0)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    id_sala INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'PROGRAMADA',
    observaciones VARCHAR(500) NOT NULL DEFAULT '',
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    CONSTRAINT fk_cita_medico
        FOREIGN KEY (id_medico) REFERENCES medicos(id_medico),
    CONSTRAINT fk_cita_sala
        FOREIGN KEY (id_sala) REFERENCES salas(id_sala),
    CONSTRAINT chk_costo
        CHECK (costo > 0),
    CONSTRAINT chk_estado
        CHECK (estado IN (
            'PROGRAMADA', 'EN_CURSO', 'COMPLETADA',
            'CANCELADA', 'NO_ASISTIO'
        ))
) ENGINE = InnoDB;

SHOW TABLES;
