// Desarrollado por: Harold Salvador
// Ejercicio 1: Arrays
import Foundation

// ==========================================
// EJEMPLO RESUELTO
// ==========================================
var notas: [Double] = []

// En ejecución normal/terminal pedirá datos con readLine()
for i in 1...3 {
    print("Ingrese la nota \(i):")
    let entrada = readLine() ?? ""
    let nota = Double(entrada) ?? 0
    notas.append(nota)
}

print("\nNotas ingresadas: \(notas)")
print("Total de notas: \(notas.count)")

var suma = 0.0
for nota in notas {
    suma += nota
}
let promedio = notas.isEmpty ? 0.0 : (suma / Double(notas.count))

print("Suma: \(suma)")
print("Promedio: \(promedio)")

if let max = notas.max(), let min = notas.min() {
    print("Nota más alta: \(max)")
    print("Nota más baja: \(min)")
}
print("Notas ordenadas: \(notas.sorted())\n")


// ==========================================
// TODO 1, 2 y 3: Registro, Búsqueda y Notas
// ==========================================

// TODO 1: Registro de 5 alumnos
var alumnos: [String] = []
for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}
print("Alumnos: \(alumnos)")

// TODO 2: Buscar un alumno
print("\nBuscar alumno:")
let buscar = readLine() ?? ""
if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// TODO 3: Notas con clasificación
var notasClase: [Double] = []
for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota
    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

let promClase = notasClase.isEmpty ? 0.0 : (sumaNotas / Double(notasClase.count))
print("Promedio: \(promClase)")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)\n")


// ==========================================
// FIX: 3 ERRORES CORREGIDOS
// ==========================================

// FIX 1: Se reemplaza el número Int(7) por un String para mantener la homogeneidad del array
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Uva")

// FIX 2: Se cambia la constante 'let' por una variable 'var' para permitir mutación
var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")

// FIX 3: Se cambia el índice 5 por el índice 4 para evitar el desbordamiento (Index out of range)
let numeros = [10, 20, 30, 40, 50]
print(numeros[4])


// ==========================================
// PREDICT
// ==========================================
var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)

print(lista)       // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres)          // PREDICT 4: ["Ana", "Carlos", "Beto"]
