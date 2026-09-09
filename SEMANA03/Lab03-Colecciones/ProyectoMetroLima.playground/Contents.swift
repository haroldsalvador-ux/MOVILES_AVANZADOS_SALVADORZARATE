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

// Prueba: confirmamos que los datos cargaron bien
print("Datos cargados: \(numeroLinea.count) líneas registradas.")
