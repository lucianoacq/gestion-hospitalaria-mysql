# Gestión hospitalaria — MySQL

Proyecto académico de Base de Datos I, Tecnicatura en Programación (UTN).

## Alcance
Base relacional con departamentos, pacientes, médicos, salas y citas. Incluye claves y restricciones, triggers de integridad, datos de ejemplo, índices, consultas, vistas, permisos y ejercicios de transacciones y concurrencia.

## Requisitos y ejecución
MySQL 8.0.16 o superior con InnoDB y MySQL Workbench. Utilizar una instancia de pruebas y una base vacía. Los scripts seleccionan expresamente `gestion_hospitalaria`.

Ejecutar en este orden:
1. `01_esquema.sql`
2. `02_catalogos.sql`
3. `02_triggers.sql`
4. `03_carga_masiva.sql`
5. `04_indices.sql`
6. `05_consultas.sql`
7. `05_explain.sql`
8. `06_vistas.sql`
9. `07_seguridad.sql`
10. `08_transacciones.sql`
11. `09_concurrencia_guiada.sql`

Consultar `README.txt` para los detalles y limitaciones de cada etapa. El script de seguridad requiere permisos administrativos y reemplazar la clave de ejemplo. Las pruebas negativas producen errores intencionales; las de concurrencia requieren dos conexiones y ejecución guiada. No ejecutar toda la carpeta de pruebas automáticamente.

## Validación
El README original documenta validaciones realizadas por el estudiante el 05/11/2026 y distingue las etapas pendientes. Durante la preparación para GitHub no se ejecutaron los scripts en un servidor MySQL.

## Autor
Luciano Acquaviva — proyecto académico.
