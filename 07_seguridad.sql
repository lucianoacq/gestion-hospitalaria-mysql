-- Usuario y privilegios: ejecutar en conexion administradora.
-- IMPORTANTE: reemplazar la clave de EJEMPLO antes de ejecutar.
-- Este archivo no revoca privilegios previamente concedidos a usuarios existentes.

-- ============================================
-- USUARIO DE SOLO LECTURA
-- IMPORTANTE: sustituir la clave de ejemplo antes de ejecutar.
-- CREATE USER IF NOT EXISTS no cambia la clave si el usuario ya existe.
-- ============================================

USE gestion_hospitalaria;

CREATE USER IF NOT EXISTS 'consulta_hospital'@'localhost'
IDENTIFIED BY 'REEMPLAZAR_POR_CLAVE_DE_PRUEBA';

-- Permitir consultar únicamente las dos vistas

GRANT SELECT
ON gestion_hospitalaria.vista_citas_operativas
TO 'consulta_hospital'@'localhost';

GRANT SELECT
ON gestion_hospitalaria.vista_resumen_departamentos
TO 'consulta_hospital'@'localhost';

-- Verificar los permisos

SHOW GRANTS FOR 'consulta_hospital'@'localhost';
