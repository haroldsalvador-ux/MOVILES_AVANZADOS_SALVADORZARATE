import Foundation

// ===== MODELOS DE DATOS (Codable) =====

struct Estacion: Codable {
    let id: Int
    let nombre: String
    let referencia: String
    let conexion: String?
}

struct Linea: Codable {
    let numero: Int
    let nombre: String
    let estado: String
    let tipo: String
    let estacionesOperativasCount: Int
    let estacionesProyectadasCount: Int
    let kmOperativos: Double
    let recorrido: String
    let cruceGeneral: String
    let estaciones: [Estacion]
}

struct MetroData: Codable {
    let lineas: [Linea]
}

// ===== JSON HARDCODEADO =====

let jsonString = """
{
  "lineas": [
    {
      "numero": 1,
      "nombre": "Línea 1",
      "estado": "Operativa",
      "tipo": "Elevada",
      "estacionesOperativasCount": 26,
      "estacionesProyectadasCount": 26,
      "kmOperativos": 34.6,
      "recorrido": "Villa El Salvador - Bayóvar (San Juan de Lurigancho)",
      "cruceGeneral": "Se conecta con el Metropolitano en la estación La Cultura. En el futuro se cruzará con la Línea 2 en la estación 28 de Julio.",
      "estaciones": [
        { "id": 1, "nombre": "Villa El Salvador", "referencia": "Av. Separadora Industrial / Cerca a la Plaza Mayor de VES", "conexion": null },
        { "id": 2, "nombre": "Parque Industrial", "referencia": "Av. Separadora Industrial con Av. El Sol / Zona Industrial VES", "conexion": null },
        { "id": 3, "nombre": "Puma Cawa", "referencia": "Av. La Unión / Sector 1 de Villa El Salvador", "conexion": null },
        { "id": 4, "nombre": "Villa María", "referencia": "Av. Pachacútec / Centro de Villa María del Triunfo", "conexion": null },
        { "id": 5, "nombre": "María Auxiliadora", "referencia": "Av. Pachacútec / Cerca al Hospital María Auxiliadora", "conexion": null },
        { "id": 6, "nombre": "San Juan", "referencia": "Av. Los Héroes / Mercado de San Juan de Miraflores", "conexion": null },
        { "id": 7, "nombre": "Atocongo", "referencia": "Av. Los Héroes / Cerca al Open Plaza Atocongo y Puente Atocongo", "conexion": "Paraderos interprovinciales hacia el Sur" },
        { "id": 8, "nombre": "Jorge Chávez", "referencia": "Av. Tomás Marsano / Cerca a la Bolichera", "conexion": null },
        { "id": 9, "nombre": "Ayacucho", "referencia": "Av. Tomás Marsano con Av. Ayacucho / Surco", "conexion": null },
        { "id": 10, "nombre": "Cabitos", "referencia": "Óvalo Higuereta / Conexión con Av. Benavides y Av. Caminos del Inca", "conexion": null },
        { "id": 11, "nombre": "Angamos", "referencia": "Av. Aviación con Av. Angamos Este / Cerca al Real Plaza Primavera", "conexion": null },
        { "id": 12, "nombre": "San Borja Sur", "referencia": "Av. Aviación con Av. San Borja Sur", "conexion": null },
        { "id": 13, "nombre": "La Cultura", "referencia": "Av. Aviación con Av. Javier Prado / Cerca al Gran Teatro Nacional y Biblioteca Nacional", "conexion": "Corredor Rojo y buses hacia Estación Central del Metropolitano" },
        { "id": 14, "nombre": "Arriola", "referencia": "Av. Aviación con Av. Nicolás Arriola / Cerca al Mercado Mayorista de Frutas", "conexion": null },
        { "id": 15, "nombre": "Gamarra", "referencia": "Av. Aviación / Acceso directo al Emporio Comercial de Gamarra", "conexion": null },
        { "id": 16, "nombre": "28 de Julio", "referencia": "Av. Aviación con Av. 28 de Julio", "conexion": "En construcción: Interconexión directa con Línea 2" },
        { "id": 17, "nombre": "Miguel Grau", "referencia": "Av. Miguel Grau / Cerca al Hospital Nacional Guillermo Almenara", "conexion": null },
        { "id": 18, "nombre": "El Ángel", "referencia": "Av. Locumba / Frente al Cementerio El Ángel", "conexion": null },
        { "id": 19, "nombre": "Presbítero Maestro", "referencia": "Av. Locumba / Frente al Cementerio Museo Presbítero Maestro", "conexion": null },
        { "id": 20, "nombre": "Caja de Agua", "referencia": "Av. Próceres de la Independencia / Entrada a San Juan de Lurigancho", "conexion": null },
        { "id": 21, "nombre": "Pirámide del Sol", "referencia": "Av. Próceres de la Independencia con Av. Pirámide del Sol", "conexion": null },
        { "id": 22, "nombre": "Los Jardines", "referencia": "Av. Próceres de la Independencia / Cerca a zonas comerciales de SJL", "conexion": null },
        { "id": 23, "nombre": "Los Postes", "referencia": "Av. Próceres de la Independencia con Av. Los Postes", "conexion": null },
        { "id": 24, "nombre": "San Carlos", "referencia": "Av. Próceres de la Independencia / Cerca a la UPN", "conexion": null },
        { "id": 25, "nombre": "San Martín", "referencia": "Av. Próceres de la Independencia / Cerca al Instituto Cibertec", "conexion": null },
        { "id": 26, "nombre": "Bayóvar", "referencia": "Av. Próceres de la Independencia / Estación final en SJL", "conexion": null }
      ]
    },
    {
      "numero": 2,
      "nombre": "Línea 2",
      "estado": "Operativa (Etapa 1A)",
      "tipo": "Subterránea",
      "estacionesOperativasCount": 5,
      "estacionesProyectadasCount": 27,
      "kmOperativos": 4.5,
      "recorrido": "Evitamiento - Mercado Santa Anita (tramo operativo). Proyecto completo: Ate - Callao",
      "cruceGeneral": "Se conecta con el Metropolitano en Estación Central. En el futuro se cruzará con la Línea 1 en la estación 28 de Julio.",
      "estaciones": [
        { "id": 1, "nombre": "Evitamiento", "referencia": "Av. Nicolás Ayllón con Vía de Evitamiento / Cerca al Mall Aventura Santa Anita", "conexion": "Conexión con buses de la Vía de Evitamiento" },
        { "id": 2, "nombre": "Óvalo Santa Anita", "referencia": "Av. Carretera Central con Av. Los Ruiseñores / Óvalo de Santa Anita", "conexion": null },
        { "id": 3, "nombre": "Colectora Industrial", "referencia": "Av. Carretera Central con Av. Colectora Industrial", "conexion": null },
        { "id": 4, "nombre": "Hermilio Valdizán", "referencia": "Av. Carretera Central / Frente al Hospital Psiquiátrico Hermilio Valdizán", "conexion": null },
        { "id": 5, "nombre": "Mercado Santa Anita", "referencia": "Av. Carretera Central / Acceso al Gran Mercado Mayorista de Lima", "conexion": "Alimentadores hacia Ate Vitarte y Carretera Central" }
      ]
    },
    {
      "numero": 3,
      "nombre": "Línea 3",
      "estado": "En proyecto",
      "tipo": "Por definir",
      "estacionesOperativasCount": 0,
      "estacionesProyectadasCount": 0,
      "kmOperativos": 0.0,
      "recorrido": "Por definir (línea en proyecto)",
      "cruceGeneral": "Aún no definido, la línea está en etapa de proyecto.",
      "estaciones": []
    },
    {
      "numero": 4,
      "nombre": "Línea 4",
      "estado": "En proyecto",
      "tipo": "Por definir",
      "estacionesOperativasCount": 0,
      "estacionesProyectadasCount": 0,
      "kmOperativos": 0.0,
      "recorrido": "Por definir (incluye ramal al Aeropuerto Jorge Chávez)",
      "cruceGeneral": "Conectará con el Aeropuerto Jorge Chávez como ramal de la Línea 2.",
      "estaciones": []
    },
    {
      "numero": 5,
      "nombre": "Línea 5",
      "estado": "En proyecto",
      "tipo": "Por definir",
      "estacionesOperativasCount": 0,
      "estacionesProyectadasCount": 0,
      "kmOperativos": 0.0,
      "recorrido": "Por definir (línea en proyecto)",
      "cruceGeneral": "Aún no definido, la línea está en etapa de proyecto.",
      "estaciones": []
    },
    {
      "numero": 6,
      "nombre": "Línea 6",
      "estado": "En proyecto",
      "tipo": "Por definir",
      "estacionesOperativasCount": 0,
      "estacionesProyectadasCount": 0,
      "kmOperativos": 0.0,
      "recorrido": "Por definir (línea en proyecto)",
      "cruceGeneral": "Aún no definido, la línea está en etapa de proyecto.",
      "estaciones": []
    }
  ]
}
"""

// Cargar y procesar el JSON en Swift
var datosMetro: MetroData?
if let jsonData = jsonString.data(using: .utf8) {
    let decoder = JSONDecoder()
    datosMetro = try? decoder.decode(MetroData.self, from: jsonData)
}

// ===== ARRAYS PARALELOS ORIGINALES (Mantenidos) =====

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
        
    } else if opcion == 3 {
        print("\n¿De qué línea quieres saber las estaciones? (1-6):")
        let linea = Int(readLine() ?? "") ?? 0
        
        if linea == 1 {
            print("La Línea 1 tiene \(estacionesOperativas[0]) estaciones operativas (recorrido: \(recorridoLinea[0])).")
        } else if linea == 2 {
            print("La Línea 2 tiene actualmente \(estacionesOperativas[1]) estaciones operativas, pero su proyecto completo contempla \(estacionesProyectadas[1]) estaciones en total.")
        } else if linea == 3 {
            print("La Línea 3 aún está en proyecto, todavía no tiene estaciones construidas.")
        } else if linea == 4 {
            print("La Línea 4 aún está en proyecto, todavía no tiene estaciones construidas.")
        } else if linea == 5 {
            print("La Línea 5 aún está en proyecto, todavía no tiene estaciones construidas.")
        } else if linea == 6 {
            print("La Línea 6 aún está en proyecto, todavía no tiene estaciones construidas.")
        } else {
            print("Esa línea no existe. El Metro de Lima y Callao solo contempla las líneas 1 a 6.")
        }
        
    } else if opcion == 4 {
        print("\n¿De qué línea quieres saber con qué se cruza? (1-6):")
        let linea = Int(readLine() ?? "") ?? 0
        
        if linea == 1 {
            print("La Línea 1: \(cruceLinea[0])")
        } else if linea == 2 {
            print("La Línea 2: \(cruceLinea[1])")
        } else if linea == 3 {
            print("La Línea 3: \(cruceLinea[2])")
        } else if linea == 4 {
            print("La Línea 4: \(cruceLinea[3])")
        } else if linea == 5 {
            print("La Línea 5: \(cruceLinea[4])")
        } else if linea == 6 {
            print("La Línea 6: \(cruceLinea[5])")
        } else {
            print("Esa línea no existe. El Metro de Lima y Callao solo contempla las líneas 1 a 6.")
        }
        
    } else if opcion == 5 {
        print("\n¿De qué línea quieres ver la ficha completa? (1-6):")
        let linea = Int(readLine() ?? "") ?? 0

        if linea >= 1 && linea <= 6 {
            let i = linea - 1
            print("\n===== FICHA DE LA LÍNEA \(numeroLinea[i]) =====")
            print("Estado: \(estadoLinea[i])")
            print("Tipo: \(tipoLinea[i])")
            print("Estaciones operativas: \(estacionesOperativas[i])")
            print("Estaciones proyectadas: \(estacionesProyectadas[i])")
            print("Kilómetros en servicio: \(kmOperativos[i])")
            print("Recorrido: \(recorridoLinea[i])")
            print("Cruces/conexiones: \(cruceLinea[i])")
        } else {
            print("Esa línea no existe. El Metro de Lima y Callao solo contempla las líneas 1 a 6.")
        }
        
    } else if opcion == 6 {
            print("\n===== PLANIFICADOR Y GESTIÓN DE VIAJES =====")
            print("Selecciona la línea en la que vas a viajar:")
            print("1) Línea 1")
            print("2) Línea 2")
            let numLineaSel = Int(readLine() ?? "") ?? 0
            
            if let metro = datosMetro, numLineaSel == 1 || numLineaSel == 2 {
                let lineaObj = metro.lineas[numLineaSel - 1]
                
                print("\nEstaciones disponibles en la \(lineaObj.nombre):")
                for est in lineaObj.estaciones {
                    print("\(est.id). \(est.nombre)")
                }
                
                print("\nIngresa el número ID de la estación de ORIGEN:")
                let idOrigen = Int(readLine() ?? "") ?? 0
                print("Ingresa el número ID de la estación de DESTINO:")
                let idDestino = Int(readLine() ?? "") ?? 0
                
                let totalEstaciones = lineaObj.estaciones.count
                if idOrigen >= 1 && idOrigen <= totalEstaciones && idDestino >= 1 && idDestino <= totalEstaciones {
                    let estOrigen = lineaObj.estaciones[idOrigen - 1]
                    let estDestino = lineaObj.estaciones[idDestino - 1]
                    
                    // 1. CÁLCULO DE ESTACIONES FALTANTES
                    let estacionesFaltantes = abs(idDestino - idOrigen)
                    
                    print("\n---------------- RESUMEN DE TU VIAJE ----------------")
                    // 2. MOSTRAR ORIGEN Y SU REFERENCIA
                    print("ORIGEN:  \(estOrigen.nombre)")
                    print("         Referencia: \(estOrigen.referencia)")
                    if let conOrg = estOrigen.conexion {
                        print("         Interconexión directa: \(conOrg)")
                    }
                    
                    // 3. MOSTRAR DESTINO Y SU REFERENCIA
                    print("\nDESTINO: \(estDestino.nombre)")
                    print("         Referencia: \(estDestino.referencia)")
                    if let conDes = estDestino.conexion {
                        print("         Interconexión directa: \(conDes)")
                    }
                    
                    print("\nESTACIONES FALTANTES: Te faltan \(estacionesFaltantes) parada(s) para llegar.")
                    
                    // 4. EVALUACIÓN DE PUNTOS DE INTERCONEXIÓN EN EL TRAYECTO
                    print("\n--- PUNTOS DE INTERCONEXIÓN EN TU TRAYECTO ---")
                    var tieneInterconexion = false
                    
                    let minID = min(idOrigen, idDestino)
                    let maxID = max(idOrigen, idDestino)
                    
                    if numLineaSel == 1 {
                        // Evaluación en Línea 1
                        if minID <= 13 && maxID >= 13 {
                            print("• Pasarás por 'La Cultura': Puedes interconectarte con el Corredor Rojo y buses hacia la Estación Central del Metropolitano.")
                            tieneInterconexion = true
                        }
                        if minID <= 16 && maxID >= 16 {
                            print("• Pasarás por '28 de Julio': Punto futuro de interconexión directa con la Línea 2 del Metro.")
                            tieneInterconexion = true
                        }
                        if minID <= 7 && maxID >= 7 {
                            print("• Pasarás por 'Atocongo': Conexión con transporte interprovincial hacia el sur de Lima.")
                            tieneInterconexion = true
                        }
                    } else if numLineaSel == 2 {
                        // Evaluación en Línea 2
                        if minID <= 1 && maxID >= 1 {
                            print("• Pasarás por 'Evitamiento': Conexión con buses de transporte público de la Vía de Evitamiento.")
                            tieneInterconexion = true
                        }
                    }
                    
                    if !tieneInterconexion {
                        print("• En este tramo no hay interconexiones principales con otros sistemas masivos.")
                    }
                    
                    print("-----------------------------------------------------")
                } else {
                    print("Número de estación inválido.")
                }
            } else {
                print("Línea no disponible para planificación en este momento.")
            }
        
    } else if opcion == 7 {
            print("\n¡Gracias por usar el sistema de consultas del Metro de Lima y Callao!")
            continuar = false
        
    } else {
        print("\n(Opción \(opcion) todavía no implementada)")
    }
}
