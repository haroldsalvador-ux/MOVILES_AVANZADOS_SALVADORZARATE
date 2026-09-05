// Desarrollado por: Harold Salvador
// Ejercicio 6: Gestión de Notas con IA
import Foundation // Importa la librería fundamental para operaciones del sistema

// 8. REGISTRO DE ALUMNOS Y NOTAS

// Declaración del diccionario para mapear cada alumno con sus 3 notas
var registroAlumnos: [String: [Double]] = [:]

// Lectura de la cantidad de alumnos a registrar desde consola
print("¿Cuántos alumnos desea registrar?")
let entradaCantidad = readLine() ?? "0" // Lee la entrada como String o usa "0" si es nil
let cantidadAlumnos = Int(entradaCantidad) ?? 0 // Convierte a Int o usa 0 por defecto

// Bucle para iterar y solicitar los datos de cada uno de los N alumnos
for i in 1...cantidadAlumnos {
    print("\n--- Registro del Alumno \(i) ---") // Imprime un encabezado por alumno
    print("Nombre del alumno:") // Solicita el nombre
    let nombre = readLine() ?? "Alumno\(i)" // Lee el nombre o genera un valor genérico
    
    var notasAlumno: [Double] = [] // Inicializa un arreglo local para guardar las 3 notas
    
    // Bucle para solicitar las 3 notas correspondientes al alumno
    for j in 1...3 {
        print("Ingrese la nota \(j) para \(nombre):") // Pide la nota especifica
        let entradaNota = readLine() ?? "0" // Lee el texto ingresado
        let nota = Double(entradaNota) ?? 0.0 // Convierte a Double o usa 0.0
        notasAlumno.append(nota) // Agrega la nota individual al arreglo del alumno
    }
    
    registroAlumnos[nombre] = notasAlumno // Asocia las notas al nombre del alumno en el diccionario
}

// 9. CÁLCULO DE PROMEDIO Y CLASIFICACIÓN

// Diccionario auxiliar para guardar el promedio final obtenido por cada alumno
var promediosAlumnos: [String: Double] = [:]

print("\n===== REPORTE DE NOTAS Y CLASIFICACIÓN =====") // Encabezado de la sección

// Bucle para procesar los datos almacenados en el diccionario principal
for (alumno, notas) in registroAlumnos {
    let suma = notas.reduce(0.0, +) // Calcula la suma de las 3 notas del alumno
    let promedio = notas.isEmpty ? 0.0 : (suma / Double(notas.count)) // Obtiene el promedio
    promediosAlumnos[alumno] = promedio // Almacena el promedio individual
    
    var clasificacion = "" // Variable para guardar el resultado del switch
    
    // Clasificación del desempeño académico según el promedio mediante switch
    switch Int(promedio) {
    case 18...20: // Rango de notas para la máxima categoría
        clasificacion = "Excelente"
    case 15...17: // Rango para desempeño destacado
        clasificacion = "Bueno"
    case 13...14: // Rango mínimo para la aprobación
        clasificacion = "Aprobado"
    default: // Aplica para promedios menores a 13
        clasificacion = "Desaprobado"
    }
    
    // Imprime en consola los resultados individuales formateados
    print("Alumno: \(alumno) | Notas: \(notas) | Promedio: \(promedio) | Estado: \(clasificacion)")
}


// 10. ESTADÍSTICAS GENERALES

// Arreglo con todos los promedios recopilados para facilitar el cálculo estadístico
let todosLosPromedios = Array(promediosAlumnos.values)

// Verifica que existan datos antes de procesar cálculos generales
if !todosLosPromedios.isEmpty {
    let sumaGeneral = todosLosPromedios.reduce(0.0, +) // Suma de todos los promedios
    let promedioGeneral = sumaGeneral / Double(todosLosPromedios.count) // Promedio global de la clase
    
    let notaMasAlta = todosLosPromedios.max() ?? 0.0 // Obtiene el promedio máximo registrado
    let notaMasBaja = todosLosPromedios.min() ?? 0.0 // Obtiene el promedio mínimo registrado
    
    // Filtra los promedios aprobados (>= 13.0) para contabilizarlos
    let cantidadAprobados = todosLosPromedios.filter { $0 >= 13.0 }.count
    
    // Calcula el porcentaje exacto de aprobados en base al total de alumnos
    let porcentajeAprobados = (Double(cantidadAprobados) / Double(todosLosPromedios.count)) * 100.0
    
    // Imprime en consola las métricas calculadas
    print("\n===== ESTADÍSTICAS DEL CURSO =====")
    print("Promedio General: \(promedioGeneral)") // Muestra el promedio global
    print("Nota Más Alta: \(notaMasAlta)") // Muestra la nota máxima alcanzada
    print("Nota Más Baja: \(notaMasBaja)") // Muestra la nota mínima alcanzada
    print("Porcentaje de Aprobados: \(porcentajeAprobados)%") // Muestra la efectividad del grupo
}


// 11. ORDENAR Y MOSTRAR POR PROMEDIO

// Ordena la lista de parejas (alumno, promedio) de mayor a menor según el promedio
let alumnosOrdenados = promediosAlumnos.sorted { $0.value > $1.value }

print("\n===== RANKING DE ALUMNOS (DE MAYOR A MENOR) =====") // Encabezado de la lista ordenada

// Recorre e imprime la tupla ordenada resultante
for (posicion, tupla) in alumnosOrdenados.enumerated() {
    print("\(posicion + 1). \(tupla.key) - Promedio: \(tupla.value)") // Muestra el puesto y datos
}
