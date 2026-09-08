# Prompts — Lab 03

## Docente: Juan Leon — Tecsup
## Herramienta: Claude

---

## Ejercicio 6 — Gestión de notas

### Prompt (CTRFE):

**CONTEXTO:**
Soy estudiante de iOS en la semana 3 del curso Programación en Móviles Avanzado. Hasta ahora solo hemos visto variables, constantes, tipos básicos, condicionales, bucles (for/while) y colecciones (Array, Dictionary, Set) en Swift usando Playground. Aún no vimos funciones personalizadas, structs, clases, ni closures.

**TAREA:**
Ayúdame a construir un programa en Swift que:
1. Pida por teclado (readLine()) el nombre de N alumnos y sus 3 notas, guardando todo en un diccionario del tipo [String: [Double]].
2. Calcule el promedio de cada alumno.
3. Clasifique a cada alumno según su promedio usando un switch, con las categorías: Excelente (17-20), Bueno (14-16.9), Aprobado (11-13.9), Desaprobado (0-10.9).
4. Calcule estadísticas generales: promedio general de la clase, la nota más alta y más baja registradas, y el porcentaje de alumnos aprobados.
5. Muestre a los alumnos ordenados de mayor a menor promedio.

**RESTRICCIONES:**
- Usar solo lo visto en las semanas 1 a 3: variables, constantes, condicionales, bucles for/while, Array, Dictionary, Set, readLine(), Double()/Int() para conversión, sorted().
- NO usar struct, class, func personalizadas, closures, protocolos ni ninguna característica avanzada.
- El código debe compilar y ejecutarse en un Playground de Xcode sin errores.
- Todo el manejo de datos debe ser con las colecciones nativas de Swift (Array, Dictionary), sin librerías externas.

**FORMATO:**
- Código Swift completo, listo para pegar en Playground.
- Comentario en CADA línea explicando qué hace (en español).
- Incluir al inicio el header: // Desarrollado por: [TU NOMBRE]
- Usar print() con salidas claras y ordenadas para cada sección (registro, promedios, clasificación, estadísticas, ranking).

**EJEMPLO:**
Para 2 alumnos con notas [15, 16, 14] y [18, 19, 20], el programa debe imprimir algo como:
```
Ana: Promedio 15.0 -> Bueno
Luis: Promedio 19.0 -> Excelente

Promedio general: 17.0
Nota más alta: 20.0
Nota más baja: 14.0
Aprobados: 100.0%

Ranking:
1. Luis - 19.0
2. Ana - 15.0
```

---

## Ejercicio 7 — Inventario con menú

### Prompt (CTRFE):

**CONTEXTO:**
Soy estudiante de iOS en la semana 3 del curso Programación en Móviles Avanzado. Ya manejo Array, Dictionary, Set, bucles for/while, condicionales y lectura de datos con readLine() en Swift/Playground. Todavía no hemos visto funciones personalizadas, structs, clases ni closures.

**TAREA:**
Ayúdame a construir un programa en Swift que administre un inventario de productos mediante un menú interactivo:
1. Al iniciar, pedir cuántos productos se van a registrar y luego, por cada uno, pedir nombre, precio y stock, guardándolos en diccionarios (por ejemplo [String: Double] para precios y [String: Int] para stock).
2. Mostrar un menú con un bucle while que se repita hasta que el usuario elija salir, con las opciones:
   1) Ver inventario completo
   2) Buscar un producto por nombre
   3) Ver productos con stock bajo (menor a 5 unidades)
   4) Ver el valor total del inventario (precio × stock de cada producto, sumado)
   5) Salir
3. Cada opción debe generar un reporte formateado y ordenado en consola.

**RESTRICCIONES:**
- Usar solo lo visto en las semanas 1 a 3: variables, constantes, condicionales, while, Array, Dictionary, readLine(), Int()/Double() para conversión.
- NO usar struct, class, func personalizadas, closures ni protocolos.
- El menú debe funcionar con un bucle while real (no repetir código manualmente para cada opción).
- El programa debe ejecutarse sin errores en un Playground de Xcode.

**FORMATO:**
- Código Swift completo, listo para pegar en Playground.
- Comentario en CADA línea explicando qué hace (en español).
- Incluir al inicio el header: // Desarrollado por: [TU NOMBRE]
- Cada opción del menú debe imprimir su reporte con separadores claros (por ejemplo usando "=====").

**EJEMPLO:**
Al elegir la opción 1, con productos "Laptop" (precio 3500, stock 3) y "Mouse" (precio 45, stock 20), debe imprimir algo como:
```
===== INVENTARIO =====
Laptop: S/. 3500.0 - Stock: 3
Mouse: S/. 45.0 - Stock: 20
```
Y al elegir la opción 3 (stock bajo), debe imprimir:
```
===== STOCK BAJO (<5) =====
Laptop: Stock 3
```