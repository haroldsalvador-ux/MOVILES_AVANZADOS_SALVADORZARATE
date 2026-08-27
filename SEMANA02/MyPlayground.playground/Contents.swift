import UIKit
import Foundation

var greeting = "Hello, playground"
// Definir el promedio por pesos

let parcial = 0.3
let trabajo = 0.3
let final = 0.4

print("Nombre del Alumno")
let alumno = readLine() ?? "Desconocido"

print ("Nota del Examen Parcial")
let exaparcial = Double(readLine() ?? "") ?? 0

print ("Nota del Examen de Trabajo")
let exatrabajo = Double(readLine() ?? "") ?? 0

print ("Nota del Examen Final")
let exafinal = Double(readLine() ?? "") ?? 0
