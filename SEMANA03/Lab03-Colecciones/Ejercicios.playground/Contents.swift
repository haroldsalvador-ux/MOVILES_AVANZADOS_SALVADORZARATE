// Desarrollado por: Harold Salvador Zarate
import Foundation

// ===== TODO 8: Eliminar duplicados =====
var numeros: [Int] = []
print("===== TODO 8: INGRESE 8 NÚMEROS =====")
for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numeros.append(n)
}
print("Con duplicados: \(numeros)")

// Convertimos a Set para eliminar duplicados y a Array de nuevo para ordenarlo
let sinDuplicados = Array(Set(numeros)).sorted()
print("Sin duplicados (ordenados): \(sinDuplicados)")


// ===== TODO 9: Comparar asistencia =====
var asistenciaLunes: Set<String> = []
print("\n===== TODO 9: ASISTENCIA LUNES =====")
for i in 1...4 {
    print("Nombre \(i) (Lunes):")
    let nombre = readLine() ?? ""
    asistenciaLunes.insert(nombre)
}

var asistenciaMartes: Set<String> = []
print("\n===== TODO 9: ASISTENCIA MARTES =====")
for i in 1...4 {
    print("Nombre \(i) (Martes):")
    let nombre = readLine() ?? ""
    asistenciaMartes.insert(nombre)
}

// Operaciones de conjuntos
let asistieronAmbosDias = asistenciaLunes.intersection(asistenciaMartes)
let soloLunes = asistenciaLunes.subtracting(asistenciaMartes)
let soloMartes = asistenciaMartes.subtracting(asistenciaLunes)

print("\n===== RESULTADOS ASISTENCIA =====")
print("Asistieron ambos días: \(asistieronAmbosDias)")
print("Solo asistieron el Lunes: \(soloLunes)")
print("Solo asistieron el Martes: \(soloMartes)")
