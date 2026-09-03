import Foundation

// MARK: - 1. MODELOS DE DATOS

enum TipoUsuario: String {
    case alumno = "Alumno"
    case docente = "Docente"
    case administrador = "Administrador"
    case coordinador = "Coordinador"
}

struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucion: Date
    let fechaEntregaReal: Date
}

struct FilaCalendario {
    let dia: Int
    let fecha: Date
    let multaDia: Double
    let acumulado: Double
}

// MARK: - 2. REGLAS DE NEGOCIO Y CONFIGURACIÓN

func diasMaximos(_ tipo: TipoUsuario) -> Int {
    switch tipo {
    case .alumno: return 7
    case .docente: return 15
    case .administrador: return 10
    case .coordinador: return 15
    }
}

func multaBase(_ tipo: TipoUsuario) -> Double {
    switch tipo {
    case .alumno: return 1.50
    case .docente: return 2.00
    case .administrador: return 3.00
    case .coordinador: return 4.00
    }
}

func fechaHoy() -> Date {
    return Calendar.current.startOfDay(for: Date())
}

// MARK: - 3. MANEJO Y VALIDACIÓN DE ENTRADAS POR CONSOLA

func leerTitulo() -> String {
    while true {
        print("Título del libro:", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces), !input.isEmpty {
            return input
        }
        print("⚠️ El título no puede estar vacío.")
    }
}

func leerTipoUsuario() -> TipoUsuario {
    print("\nTipo de usuario:")
    print("1. Alumno")
    print("2. Docente")
    print("3. Administrador")
    print("4. Coordinador")

    while true {
        print("Selecciona (1-4):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
            switch input {
            case "1": return .alumno
            case "2": return .docente
            case "3": return .administrador
            case "4": return .coordinador
            default: print("⚠️ Opción inválida. Ingresa de nuevo.")
            }
        }
    }
}

func leerFechaPrestamo() -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    let hoy = fechaHoy()

    while true {
        print("\nFecha de préstamo (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            let fechaSinHora = Calendar.current.startOfDay(for: fecha)

            if fechaSinHora < hoy {
                print("⚠️ No puedes registrar préstamos con fechas anteriores a hoy (\(formatter.string(from: hoy))).")
                continue
            }
            return fecha
        }
        print("⚠️ Fecha inválida. Usa el formato dd/MM/yyyy")
    }
}

func leerFechaDevolucion(fechaPrestamo: Date, tipo: TipoUsuario) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    let maxDias = diasMaximos(tipo)
    let fechaLimite = Calendar.current.date(byAdding: .day, value: maxDias, to: fechaPrestamo)!

    while true {
        print("Fecha de devolución pactada (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha <= fechaPrestamo {
                print("⚠️ La fecha de devolución debe ser posterior a la de préstamo.")
                continue
            }
            if fecha > fechaLimite {
                print("⚠️ Excede el límite de \(maxDias) días permitidos para \(tipo.rawValue) (\(formatter.string(from: fechaLimite))).")
                continue
            }
            return fecha
        }
        print("⚠️ Fecha inválida. Usa el formato dd/MM/yyyy")
    }
}

func leerFechaEntregaReal(fechaPrestamo: Date) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    while true {
        print("Fecha de entrega real (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha < fechaPrestamo {
                print("⚠️ La fecha de entrega real no puede ser anterior a la de préstamo.")
                continue
            }
            return fecha
        }
        print("⚠️ Fecha inválida. Usa el formato dd/MM/yyyy")
    }
}

func ingresarDatos() -> Prestamo {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    print("=== SISTEMA DE PRÉSTAMO DE LIBROS ===")
    print("Fecha del sistema: \(formatter.string(from: fechaHoy()))\n")

    let titulo = leerTitulo()
    let tipo = leerTipoUsuario()
    let fechaPrestamo = leerFechaPrestamo()
    let fechaDevolucion = leerFechaDevolucion(fechaPrestamo: fechaPrestamo, tipo: tipo)
    let fechaEntregaReal = leerFechaEntregaReal(fechaPrestamo: fechaPrestamo)

    return Prestamo(
        tituloLibro: titulo,
        tipoUsuario: tipo,
        fechaPrestamo: fechaPrestamo,
        fechaDevolucion: fechaDevolucion,
        fechaEntregaReal: fechaEntregaReal
    )
}

// MARK: - 4. OPERACIONES Y CÁLCULOS DE MULTAS

func calcularDiasAtraso(fechaDevolucion: Date, fechaEntregaReal: Date) -> Int {
    let diferencia = Calendar.current.dateComponents([.day], from: fechaDevolucion, to: fechaEntregaReal)
    return max(0, diferencia.day ?? 0)
}

// TU FUNCIÓN EXACTA DE MULTA POR DÍA
func multaPorDia(dia: Int, tipo: TipoUsuario) -> Double {
    let base = multaBase(tipo)
    switch dia {
    case 1...3: return base * 0
    case 4...6: return base * 1.25
    case 7...10: return base * 1.5
    default:    return base * 2.0
    }
}

func estaSuspendido(diasAtraso: Int) -> Bool {
    return diasAtraso > 20
}

func situacionUsuario(diasAtraso: Int) -> String {
    return estaSuspendido(diasAtraso: diasAtraso) ? "❌ SUSPENDIDO" : "✅ HABILITADO"
}

func generarCalendario(fechaDevolucion: Date, diasAtraso: Int, tipo: TipoUsuario) -> [FilaCalendario] {
    var calendario: [FilaCalendario] = []
    var acumulado: Double = 0.0

    guard diasAtraso > 0 else { return [] }

    for dia in 1...diasAtraso {
        let fecha = Calendar.current.date(byAdding: .day, value: dia, to: fechaDevolucion)!
        let multa = multaPorDia(dia: dia, tipo: tipo)
        acumulado += multa

        calendario.append(FilaCalendario(
            dia: dia,
            fecha: fecha,
            multaDia: multa,
            acumulado: acumulado
        ))
    }

    return calendario
}

func calcularMultaTotal(calendario: [FilaCalendario]) -> Double {
    return calendario.last?.acumulado ?? 0.0
}

// MARK: - 5. EJECUCIÓN PRINCIPAL

let prestamo = ingresarDatos()

let diasAtraso = calcularDiasAtraso(
    fechaDevolucion: prestamo.fechaDevolucion,
    fechaEntregaReal: prestamo.fechaEntregaReal
)

let calendario = generarCalendario(
    fechaDevolucion: prestamo.fechaDevolucion,
    diasAtraso: diasAtraso,
    tipo: prestamo.tipoUsuario
)

let multaTotal = calcularMultaTotal(calendario: calendario)
let usuarioSuspendido = estaSuspendido(diasAtraso: diasAtraso)
let situacion = situacionUsuario(diasAtraso: diasAtraso)

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"
formatter.locale = Locale(identifier: "es_PE")

print("\n==========================================")
print("📌 RESUMEN DEL PRÉSTAMO")
print("==========================================")
print("Libro: \(prestamo.tituloLibro)")
print("Usuario: \(prestamo.tipoUsuario.rawValue)")
print("Días de atraso: \(diasAtraso)")
print("Situación del usuario: \(situacion)")

if usuarioSuspendido {
    print("\n------------------------------------------")
    print("⛔ ATENCIÓN: El usuario ha superado los 20 días de atraso (\(diasAtraso) días).")
    print("El estado del usuario pasa a SUSPENDIDO de todo préstamo de libro.")
    print("------------------------------------------")
} else if diasAtraso > 0 {
    print("\n--- DETALLE DE MULTAS POR DÍA ---")
    print("Día\tFecha\t\tMulta día\tAcumulado")
    for fila in calendario {
        print("\(fila.dia)\t\(formatter.string(from: fila.fecha))\tS/ \(String(format: "%.2f", fila.multaDia))\t\tS/ \(String(format: "%.2f", fila.acumulado))")
    }
    print("------------------------------------------")
    print("Multa Total a pagar: S/ \(String(format: "%.2f", multaTotal))")
} else {
    print("\n✅ Sin multas. El libro fue entregado a tiempo.")
}
