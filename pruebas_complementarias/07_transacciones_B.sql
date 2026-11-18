-- ============================================
-- TFI BASE DE DATOS I
-- SISTEMA DE GESTION HOSPITALARIA
-- ETAPA 5: TRANSACCIONES Y CONCURRENCIA
-- CONEXION B
-- ============================================

USE gestion_hospitalaria;

-- IMPORTANTE:
-- Este archivo debe ejecutarse por bloques,
-- alternando con la CONEXION A.
-- NO ejecutar todo de una sola vez.


-- ============================================
-- PRUEBA 1: READ COMMITTED


-- PASO B1:
-- Ejecutar despues de la primera lectura
-- del PASO A2 de la CONEXION A.
--
-- Modificamos los cupos de 5 a 4
-- y confirmamos el cambio.

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 4
WHERE id_recurso = 1;

COMMIT;

-- VOLVER A LA CONEXION A:
-- Ejecutar el PASO A3.
-- La segunda lectura debe mostrar 4 cupos.


-- ============================================
-- PRUEBA 2: REPEATABLE READ


-- PASO B2:
-- Ejecutar despues de la primera lectura
-- del PASO A5 de la CONEXION A.
--
-- La CONEXION A ya restablecio los cupos a 5.
-- Ahora volvemos a modificarlos a 4.

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 4
WHERE id_recurso = 1;

COMMIT;

-- VOLVER A LA CONEXION A:
-- Ejecutar el PASO A6.
-- La segunda lectura debe seguir mostrando
-- 5 cupos por el aislamiento REPEATABLE READ.


-- ============================================
-- PRUEBA 3: SIMULACION DE DEADLOCK


-- PASO B3:
-- Ejecutar despues del PASO A9.
--
-- En A ya existe una transaccion abierta
-- que bloqueo el recurso 1.
--
-- Ahora B bloquea el recurso 2.

START TRANSACTION;

UPDATE prueba_transacciones
SET cupos_disponibles = 4
WHERE id_recurso = 2;

-- IMPORTANTE:
-- NO ejecutar COMMIT todavia.


-- VOLVER A LA CONEXION A:
-- Ejecutar el PASO A10.
--
-- A intentara modificar el recurso 2,
-- pero quedara esperando porque B
-- mantiene bloqueado ese recurso.


-- PASO B4:
-- Mientras A espera, ejecutar este UPDATE.
--
-- B intenta modificar el recurso 1,
-- que esta bloqueado por A.
--
-- Se produce un bloqueo mutuo (DEADLOCK).

UPDATE prueba_transacciones
SET cupos_disponibles = 3
WHERE id_recurso = 1;


-- En nuestra prueba, MySQL detecto
-- el DEADLOCK y devolvio el ERROR 1213
-- en la CONEXION A.
--
-- MySQL revirtio automaticamente
-- la transaccion A.
--
-- Como B pudo completar su UPDATE,
-- ahora confirmamos sus cambios.


-- PASO B5: CONFIRMAR LA TRANSACCION B
-- Ejecutar solo si B4 finalizo correctamente.

COMMIT;


-- ============================================
-- PRUEBA 4: ROLLBACK Y REINTENTO


-- No se requieren mas modificaciones
-- desde la CONEXION B.
--
-- VOLVER A LA CONEXION A:
--
-- PASO A11: ROLLBACK y verificacion.
-- PASO A12: Reintentar las operaciones.
-- PASO A13: Verificar los valores finales.
--
-- RESULTADO OBTENIDO:
-- Consultorio A: 4 cupos
-- Consultorio B: 3 cupos


-- ============================================
-- FIN DEL SCRIPT - CONEXION B