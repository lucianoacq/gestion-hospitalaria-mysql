-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 5: TRANSACCIONES Y CONCURRENCIA
-- CONEXION A
-- ============================================

USE gestion_hospitalaria;

-- IMPORTANTE:
-- Este archivo debe ejecutarse por bloques.
-- Algunas operaciones requieren intervenir
-- desde la CONEXION B antes de continuar.


-- ============================================
-- PRUEBA 1: READ COMMITTED


-- PASO A1: PREPARAR LOS DATOS

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 5
WHERE id_recurso IN (1, 2);

COMMIT;

SELECT *
FROM prueba_transacciones;


-- PASO A2: INICIAR LA TRANSACCION

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

START TRANSACTION;

-- Primera lectura: esperamos 5 cupos

SELECT *
FROM prueba_transacciones
WHERE id_recurso = 1;


-- PAUSA:
-- Ahora la CONEXION B modifica los cupos
-- del recurso 1 a 4 y ejecuta COMMIT.


-- PASO A3: SEGUNDA LECTURA

-- Esperamos 4 cupos porque READ COMMITTED
-- permite ver cambios confirmados por
-- otras transacciones.

SELECT *
FROM prueba_transacciones
WHERE id_recurso = 1;

COMMIT;


-- ============================================
-- PRUEBA 2: REPEATABLE READ


-- PASO A4: RESTABLECER LOS DATOS

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 5
WHERE id_recurso = 1;

COMMIT;


-- PASO A5: INICIAR LA TRANSACCION

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

START TRANSACTION;

-- Primera lectura: esperamos 5 cupos

SELECT *
FROM prueba_transacciones
WHERE id_recurso = 1;


-- PAUSA:
-- Ahora la CONEXION B modifica los cupos
-- del recurso 1 a 4 y ejecuta COMMIT.


-- PASO A6: SEGUNDA LECTURA

-- Esperamos seguir viendo 5 cupos
-- porque REPEATABLE READ mantiene
-- una vista consistente de los datos.

SELECT *
FROM prueba_transacciones
WHERE id_recurso = 1;

COMMIT;


-- PASO A7: LECTURA DESPUES DEL COMMIT

-- Ahora esperamos ver 4 cupos.

SELECT *
FROM prueba_transacciones
WHERE id_recurso = 1;


-- ============================================
-- PRUEBA 3: SIMULACION DE DEADLOCK


-- PASO A8: RESTABLECER LOS DOS RECURSOS
-- Ejecutar cuando ambas sesiones hayan
-- terminado sus transacciones anteriores.

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 5
WHERE id_recurso IN (1, 2);

COMMIT;

SELECT *
FROM prueba_transacciones;


-- PASO A9: BLOQUEAR EL PRIMER RECURSO

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 4
WHERE id_recurso = 1;


-- PAUSA:
-- La CONEXION B inicia una transaccion
-- y modifica el recurso 2 a 4.
-- No debe ejecutar COMMIT todavia.


-- PASO A10: INTENTAR MODIFICAR EL RECURSO 2

-- Esta instruccion queda esperando porque
-- el recurso 2 esta bloqueado por B.

UPDATE prueba_transacciones
SET cupos_disponibles = 3
WHERE id_recurso = 2;


-- PAUSA:
-- Mientras A espera, la CONEXION B intenta
-- modificar el recurso 1 a 3.
--
-- Se produce un DEADLOCK.
--
-- En nuestra prueba, MySQL cancelo
-- la transaccion A con el ERROR 1213.
--
-- El motor InnoDB realiza un ROLLBACK
-- automatico de la transaccion afectada.


-- ============================================
-- PRUEBA 4: ROLLBACK Y REINTENTO


-- PASO A11: LIMPIAR LA SESION
-- Solo despues de que A haya recibido
-- el error 1213 y B haya ejecutado COMMIT.

ROLLBACK;

SELECT *
FROM prueba_transacciones;


-- PASO A12: REINTENTAR LA TRANSACCION

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 4
WHERE id_recurso = 1;

UPDATE prueba_transacciones
SET cupos_disponibles = 3
WHERE id_recurso = 2;

COMMIT;


-- PASO A13: VERIFICAR EL RESULTADO

SELECT *
FROM prueba_transacciones;

-- RESULTADO ESPERADO:
-- Consultorio A: 4 cupos
-- Consultorio B: 3 cupos


-- ============================================
-- FIN DEL SCRIPT - CONEXION A