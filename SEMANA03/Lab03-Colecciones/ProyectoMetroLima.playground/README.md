# Sistema de Consultas — Metro de Lima y Callao

**Curso:** Programación en Móviles Avanzado  
**Docente:** Juan Leon — Tecsup  
**Lenguaje:** Swift (Xcode Playground)  
**Autor:** Harold Salvador  

## Descripción general

Aplicación de consola desarrollada en Swift que permite consultar información sobre las líneas del Metro de Lima y Callao (Perú), usando datos reales publicados sobre la Red Básica del Metro (2026). El programa guarda la información de cada línea en arrays paralelos y muestra un menú numerado donde el usuario elige qué desea consultar. Cada opción del menú se resuelve mediante estructuras condicionales (`if`, `else if`, `else`).

## Historial de Commits

A continuación se detalla el desarrollo incremental del proyecto registrado en GitHub:

| Hash | Mensaje del Commit | Descripción / Avance |
|---|---|---|
| `9e96816` | `define arrays de datos de las 6 lineas de metro (es la estructura de los datos)` | Definición de los arrays paralelos con datos del metro. |
| `2fe8808` | `se esta agregando un menú principal con 6 opciones dentro del bucle while (el menu y el loop, pero aun no tiene logica)` | Creación de la interfaz de consola y flujo base. |
| `bf7af1e` | `se agrego el el calculo de liena en Lima y cuantas estan activas (un conteo con "if" dentro de un "for")` | Implementación de la Opción 1 del menú. |
| `89fb9c2` | `listado de las 6 lineas completo usando if y else` | Implementación de la Opción 2 del menú. |
| `6a08acd` | `se agregaron las opciones 3 y 4 que nos ayudan a consultar estaciones y cruces de una linea con otra` | Implementación conjunta de las Opciones 3 y 4. |
| `1b2ba19` | `imprime la ficha completa de una linea con todos sus datos` | Implementación de la Opción 5 del menú. |

## Objetivo

Practicar el uso de arrays, bucles (`while`, `for`) y estructuras condicionales en Swift, aplicados a un caso real de consulta de datos.

## Estructura de datos

La información de las 6 líneas se guarda en arrays paralelos, donde la posición 0 corresponde a la Línea 1, la posición 1 a la Línea 2, y así sucesivamente:

| Array | Contenido |
|---|---|
| `numeroLinea` | Número de cada línea (1 al 6) |
| `estadoLinea` | Operativa, Operativa (Etapa 1A) o En proyecto |
| `tipoLinea` | Elevada, Subterránea o Por definir |
| `estacionesOperativas` | Estaciones actualmente en servicio |
| `estacionesProyectadas` | Estaciones totales al finalizar la construcción |
| `kmOperativos` | Kilómetros de vía en servicio |
| `recorridoLinea` | Distritos o puntos de inicio y fin |
| `cruceLinea` | Conexiones con otras líneas, el Metropolitano o el aeropuerto |

## Requerimientos funcionales

| ID | Requerimiento | Cómo se cumple en el código |
|---|---|---|
| RF01 | El sistema debe mostrar un menú principal con las opciones disponibles, repitiéndose hasta que el usuario decida salir. | Bucle `while continuar` que imprime las 6 opciones en cada vuelta. |
| RF02 | El sistema debe indicar cuántas líneas de metro tiene el Perú y cuántas están operativas actualmente. | Opción 1: usa `numeroLinea.count` y un `for` con `if` que cuenta los estados "Operativa" u "Operativa (Etapa 1A)". |
| RF03 | El sistema debe listar todas las líneas junto con su estado actual y estaciones en servicio. | Opción 2: recorre los arrays con un `for` y un `if/else` que diferencia líneas operativas de las que están en proyecto. |
| RF04 | El sistema debe permitir consultar cuántas estaciones tiene una línea específica, ingresada por el usuario. | Opción 3: pide el número de línea (1-6) y usa una cadena de `if / else if` para devolver estaciones operativas y proyectadas de esa línea. |
| RF05 | El sistema debe permitir consultar con qué otras líneas o sistemas de transporte se cruza una línea específica. | Opción 4: pide el número de línea y usa `if / else if` para mostrar el contenido de `cruceLinea` correspondiente. |
| RF06 | El sistema debe permitir ver la ficha completa de una línea (estado, tipo, estaciones, km, recorrido y cruces) en una sola consulta. | Opción 5: valida que la línea esté entre 1 y 6, calcula su índice (`linea - 1`) y muestra todos los datos de esa posición en los arrays. |
| RF07 | El sistema debe validar los datos ingresados por el usuario y evitar que el programa se detenga ante una entrada inválida. | Uso de `Int(readLine() ?? "") ?? 0` en cada entrada, y un `else` final en cada cadena de condicionales para números de línea u opciones que no existen. |
| RF08 | El sistema debe permitir salir del programa de forma controlada. | Opción 6: cambia `continuar` a `false`, lo que rompe el bucle `while`. |

## Requerimientos no funcionales

- El programa debe ejecutarse sin errores dentro de un Playground de Xcode.
- Los mensajes de salida deben estar en español y ser claros para cualquier usuario.
- Los datos de las líneas deben poder actualizarse fácilmente modificando los arrays, sin tocar la lógica del menú.

## Menú de opciones

```text
1) ¿Cuántas líneas de metro tiene el Perú?
2) Ver todas las líneas y su estado
3) ¿Cuántas estaciones tiene una línea específica?
4) ¿Con qué se cruza una línea específica?
5) Ver ficha completa de una línea
6) Salir