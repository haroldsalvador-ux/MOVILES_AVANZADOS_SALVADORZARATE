# Registro de prompts utilizados — Laboratorio 02

## Herramienta de IA utilizada
Claude

---

## Ejercicio 6: Carrito Mejorado con IA

### Prompt (estructura CTRFE):
```
- **CONTEXTO:** Estudio Diseño y Desarrollo de Software en Tecsup, actualmente en el
  curso de Programación Móvil Avanzado, desarrollando en Swift Playgrounds dentro de
  la rama `ai-assisted`.
- **TAREA:** Necesito que generes el código para potenciar un carrito de compras
  incorporando: 1) un descuento del 5% por cantidad cuando un producto alcance 3
  unidades o más, 2) un cupón "DESCUENTO20" que sume un 20% adicional de rebaja,
  3) envío sin costo si el total supera S/. 3000 y, de lo contrario, un cobro fijo de
  S/. 25.00, 4) acumulación de puntos de fidelidad a razón de 1 punto por cada S/. 100
  gastados, y 5) una validación que detecte precios negativos o cantidades en cero y
  despliegue un mensaje de error.
- **RESTRICCIONES:** Usar únicamente Swift básico compatible con Playground; nada de
  arreglos ni colecciones, solo variables y constantes individuales combinadas con
  condicionales; evitar funciones complejas.
- **FORMATO:** Entregar código Swift totalmente funcional, comentando cada línea de
  forma descriptiva, y mostrando el ticket final en consola alineado con dos decimales.
- **EJEMPLO:**
"swift" let factorDescuento = cantidad >= 3 ? 0.95 : 1.0 // Reduce el precio un 5% cuando la cantidad comprada es 3 o más
```

### ¿Funcionó a la primera?
Sí, la IA entregó de una vez la lógica completa cubriendo las cinco condiciones pedidas.

### ¿La IA usó algo que no conocías?
No, se apoyó en estructuras que ya manejaba, sin recurrir a nada avanzado.

---

## Ejercicio 7: Juego de adivinanza

### Prompt (estructura CTRFE):
```
- **CONTEXTO:** Estudio Diseño y Desarrollo de Software en Tecsup, actualmente en el
  curso de Programación Móvil Avanzado, desarrollando en Swift Playgrounds dentro de
  la rama `ai-assisted`.
- **TAREA:** Elabora un minijuego de adivinar números en Swift que cumpla con:
  1. Definir un número secreto fijo (por ejemplo, 42).
  2. Simular 5 intentos mediante variables separadas (`intentoN1 = 20`,
     `intentoN2 = 50`, etc.).
  3. Recorrer y evaluar esos intentos usando un bucle `while`.
  4. Indicar en cada intento si el número propuesto es "Muy alto", "Muy bajo" o
     "¡Correcto!".
  5. Llevar la cuenta de cuántos intentos hicieron falta para acertar.
  6. Si tras 5 intentos no se acertó, mostrar "Perdiste. El número era: X".
- **RESTRICCIONES:** Solo Swift básico dentro de Playground, sin usar `Array` ni
  colecciones; limitarse a variables simples, un bucle `while` y estructuras
  `if/else`.
- **FORMATO:** Código Swift ejecutable de principio a fin, con un comentario en cada
  línea explicando la lógica de comparación, y una salida ordenada en consola.
- **EJEMPLO:**
"swift" while turnoActual <= 5 && !haAdivinado { // Continúa el ciclo mientras haya intentos disponibles y aún no se gane
```

### ¿Funcionó a la primera?
Sí, construyó correctamente el bucle `while` evaluando las condiciones numéricas y
deteniéndose al agotarse los intentos.

### ¿La IA usó algo que no conocías?
No, empleó variables, constantes y operadores de comparación que ya conocía.
