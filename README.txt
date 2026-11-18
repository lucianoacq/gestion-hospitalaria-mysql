TFI - BASES DE DATOS I / SISTEMA DE GESTION HOSPITALARIA
ZIP LIMPIO - SCRIPTS Y PRUEBAS COMPLEMENTARIAS

REQUISITOS: MySQL 8.0+, InnoDB; ejecutar desde MySQL Workbench.
AVISO: Estos archivos usan expresamente gestion_hospitalaria;.
IMPORTANTE: los scripts de entrega seleccionan gestion_hospitalaria.
No ejecutarlos sobre una base original que se quiera preservar.
La validacion independiente se hizo usando copias con el nombre de base adaptado.
Para pruebas usar el ZIP separado TFI_BDI_Validacion_Segura.zip.

ORDEN DE EJECUCION EN UNA BASE NUEVA/VACIA
 1. 01_esquema.sql              cinco tablas, claves y restricciones
 2. 02_catalogos.sql            departamentos y salas
 3. 02_triggers.sql             tres triggers de integridad
 4. 03_carga_masiva.sql         pacientes, medicos, citas
 5. 04_indices.sql              indices de optimizacion
 6. 05_consultas.sql            consultas y vista detallada
 7. 05_explain.sql              comparaciones EXPLAIN
 8. 06_vistas.sql               vistas operativas y resumen
 9. 07_seguridad.sql            usuario y permisos (ver nota)
10. 08_transacciones.sql        tabla auxiliar de pruebas
11. 09_concurrencia_guiada.sql instrucciones y verificacion basica

PRUEBAS COMPLEMENTARIAS (NO CORRER TODAS AUTOMATICAMENTE)
La carpeta pruebas_complementarias/ contiene exclusivamente archivos adicionales
no duplicados en la raiz: datos y casos de prueba, seguridad, reintentos,
mediciones y procedimientos para dos conexiones A/B.
Los scripts A/B requieren ejecutar bloques alternados en DOS conexiones.
Las pruebas negativas estan disenadas para producir errores intencionales.
La prueba de contencion usa recursos auxiliares y puede producir el error 1205.

SEGURIDAD
07_seguridad.sql contiene una CLAVE DE EJEMPLO y crea un usuario en el servidor.
Reemplazar la clave y ejecutarlo solo con permisos de administrador,
en un entorno controlado. CREATE USER IF NOT EXISTS no cambia claves existentes.

IDEMPOTENCIA Y LIMITACIONES
- Tablas: CREATE TABLE IF NOT EXISTS no repara una estructura previa distinta.
- Catalogos/carga: emplean condiciones para evitar duplicados.
- Triggers: DROP TRIGGER IF EXISTS seguido por CREATE TRIGGER.
- Vistas: CREATE OR REPLACE.
- Indices: se consultan metadatos antes de agregar.
- 08_transacciones.sql restablece los cupos en tabla auxiliar al reejecutarse.
- No se certifico ejecucion automatica de este paquete completo sobre MySQL nuevo.
  Se recomienda la validacion guiada separada.

Este paquete conserva las implementaciones de los scripts principales; solo
elimina copias redundantes y reorganiza pruebas unicas.

RESULTADO DE VALIDACION (05-11-2026)
El estudiante ejecuto en Workbench sobre gestion_hospitalaria_validacion_final
las versiones adaptadas de los scripts principales de esquema, catalogos,
triggers, carga masiva, indices, consultas, vistas y tabla auxiliar.
Se verificaron cantidades y segundas ejecuciones de estructura, catalogos,
triggers, carga, indices, vistas y tabla auxiliar.
Los scripts compartidos son identicos salvo por el nombre de base.
NO se comprobo la ejecucion de 05_explain.sql, 07_seguridad.sql,
09_concurrencia_guiada.sql ni todas las pruebas complementarias en esta sesion.
