import Foundation

// ===== DATOS DEL METRO (arrays paralelos, uno por línea, del 1 al 6) =====

let numeroLinea: [Int] = [1, 2, 3, 4, 5, 6]

let estadoLinea: [String] = [
    "Operativa",
    "Operativa (Etapa 1A)",
    "En proyecto",
    "En proyecto",
    "En proyecto",
    "En proyecto"
]

let tipoLinea: [String] = [
    "Elevada",
    "Subterránea",
    "Por definir",
    "Por definir",
    "Por definir",
    "Por definir"
]

let estacionesOperativas: [Int] = [26, 5, 0, 0, 0, 0]
let estacionesProyectadas: [Int] = [26, 27, 0, 0, 0, 0]
let kmOperativos: [Double] = [34.6, 4.5, 0.0, 0.0, 0.0, 0.0]

let recorridoLinea: [String] = [
    "Villa El Salvador - Bayóvar (San Juan de Lurigancho)",
    "Evitamiento - Mercado Santa Anita (tramo operativo). Proyecto completo: Ate - Callao",
    "Por definir (línea en proyecto)",
    "Por definir (línea en proyecto, incluye ramal al Aeropuerto Jorge Chávez)",
    "Por definir (línea en proyecto)",
    "Por definir (línea en proyecto)"
]

let cruceLinea: [String] = [
    "Se conecta con el Metropolitano en la estación La Cultura. En el futuro se cruzará con la Línea 2 en la estación 28 de Julio (en construcción).",
    "Se conecta con el Metropolitano en Estación Central. En el futuro se cruzará con la Línea 1 en la estación 28 de Julio (en construcción). Incluye el ramal hacia la Línea 4 (Aeropuerto Jorge Chávez).",
    "Aún no definido, la línea está en etapa de proyecto.",
    "Conectará con el Aeropuerto Jorge Chávez como ramal de la Línea 2.",
    "Aún no definido, la línea está en etapa de proyecto.",
    "Aún no definido, la línea está en etapa de proyecto."
]

// ===== MENÚ PRINCIPAL =====
var continuar = true

print("=============================================")
print(" METRO DE LIMA Y CALLAO - SISTEMA DE CONSULTAS")
print("=============================================")

while continuar {
    print("\n¿Qué deseas consultar?")
    print("1) ¿Cuántas líneas de metro tiene el Perú?")
    print("2) Ver todas las líneas y su estado")
    print("3) ¿Cuántas estaciones tiene una línea específica?")
    print("4) ¿Con qué se cruza una línea específica?")
    print("5) Ver ficha completa de una línea")
    print("6) Salir")
    print("Elige una opción (1-6):")
    
    let opcion = Int(readLine() ?? "") ?? 0
    
    if opcion == 1 {
        print("\nEl Perú tiene \(numeroLinea.count) líneas de metro contempladas en la Red Básica del Metro de Lima y Callao.")
        
        var operativas = 0
        for estado in estadoLinea {
            if estado == "Operativa" || estado == "Operativa (Etapa 1A)" {
                operativas += 1
            }
        }
        print("De esas \(numeroLinea.count), actualmente \(operativas) están operativas y las demás siguen en proyecto.")
        
        } else if opcion == 2 {
        print("\n===== ESTADO DE TODAS LAS LÍNEAS =====")
        for i in 0..<numeroLinea.count {
            if estadoLinea[i] == "Operativa" || estadoLinea[i] == "Operativa (Etapa 1A)" {
                print("Línea \(numeroLinea[i]): \(estadoLinea[i]) - \(estacionesOperativas[i]) estaciones en servicio")
            } else {
                print("Línea \(numeroLinea[i]): \(estadoLinea[i]) - todavía sin estaciones en servicio")
            }
        }

    } else if opcion == 6 {
        print("\n¡Gracias por usar el sistema de consultas del Metro de Lima y Callao!")
        continuar = false

    } else {
        print("\n(Opción \(opcion) todavía no implementada)")
    }
}
