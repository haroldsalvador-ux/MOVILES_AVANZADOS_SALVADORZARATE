import Foundation

// MARK: - Fase 1: Ingreso de datos

// Tipo de Usuario
enum TipoUsuario: String {
    case alumno = "Alumno"
    case docente = "Docente"
    case administrador = "Administrador"
}

// Entidad Prestamo
struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucion: Date
    let fechaEntregaReal: Date
}

// Días máximos por tipo
func diasMaximos(_ tipo: TipoUsuario) -> Int {
    switch tipo {
    case .alumno: return 7
    case .docente: return 15
    case .administrador: return 10
    }
}

// Leer título con validación
func leerTitulo() -> String {
    while true {
        print("Título del libro:", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces), !input.isEmpty {
            return input
        }
        print("⚠️  El título no puede estar vacío.")
    }
}

// Leer tipo de usuario con validación
func leerTipoUsuario() -> TipoUsuario {
    print("\nTipo de usuario:")
    print("1. Alumno")
    print("2. Docente")
    print("3. Administrador")

    while true {
        print("Selecciona (1-3):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces) {
            switch input {
            case "1": return .alumno
            case "2": return .docente
            case "3": return .administrador
            default: print("⚠️  Opción inválida. Ingresa de nuevo.")
            }
        }
    }
}

// Leer fecha con validación de formato
func leerFecha(_ mensaje: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    while true {
        print(mensaje, terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {
            return fecha
        }
        print("⚠️  Fecha inválida. Usa el formato dd/MM/yyyy (ej: 18/10/2026)")
    }
}

// Leer fecha devolución con validaciones
func leerFechaDevolucion(fechaPrestamo: Date, tipo: TipoUsuario) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    let maxDias = diasMaximos(tipo)
    let fechaLimite = Calendar.current.date(byAdding: .day, value: maxDias, to: fechaPrestamo)!

    while true {
        print("Fecha de devolución (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha <= fechaPrestamo {
                print("⚠️  La fecha de devolución debe ser posterior a la fecha de préstamo.")
                continue
            }
            if fecha > fechaLimite {
                print("⚠️  La fecha de devolución excede el límite permitido (\(formatter.string(from: fechaLimite))) para \(tipo.rawValue).")
                continue
            }
            return fecha
        }
        print("⚠️  Fecha inválida. Usa el formato dd/MM/yyyy (ej: 18/10/2026)")
    }
}

// Leer fecha entrega real con validaciones
func leerFechaEntregaReal(fechaPrestamo: Date) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")

    while true {
        print("Fecha de entrega real (dd/MM/yyyy):", terminator: " ")
        if let input = readLine()?.trimmingCharacters(in: .whitespaces),
           let fecha = formatter.date(from: input) {

            if fecha < fechaPrestamo {
                print("⚠️  La fecha de entrega real no puede ser anterior a la fecha de préstamo.")
                continue
            }
            return fecha
        }
        print("⚠️  Fecha inválida. Usa el formato dd/MM/yyyy (ej: 18/10/2026)")
    }
}

// Ingreso de datos principal
func ingresarDatos() -> Prestamo {
    print("=== SISTEMA DE PRÉSTAMO DE LIBROS ===\n")

    let titulo = leerTitulo()
    let tipo = leerTipoUsuario()
    let fechaPrestamo = leerFecha("\nFecha de préstamo (dd/MM/yyyy):")
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

// MARK: - Fase 2: Operaciones

// Fecha límite
func calcularFechaLimite(fechaPrestamo: Date, tipo: TipoUsuario) -> Date {
    let dias = diasMaximos(tipo)
    return Calendar.current.date(byAdding: .day, value: dias, to: fechaPrestamo)!
}

// Días de atraso usando fecha entrega real
func calcularDiasAtraso(fechaDevolucion: Date, fechaEntregaReal: Date) -> Int {
    let diferencia = Calendar.current.dateComponents([.day], from: fechaDevolucion, to: fechaEntregaReal)
    return max(0, diferencia.day ?? 0)
}

// Multa base por tipo
func multaBase(_ tipo: TipoUsuario) -> Double {
    switch tipo {
    case .alumno: return 1.50
    case .docente: return 2.00
    case .administrador: return 3.00
    }
}

// Multa por día según tramo
func multaPorDia(dia: Int, tipo: TipoUsuario) -> Double {
    let base = multaBase(tipo)
    switch dia {
    case 1...3: return base
    case 4...6: return base * 1.5
    default:    return base * 2.0
    }
}

// Estado del libro
func estadoLibro(fechaDevolucion: Date, fechaEntregaReal: Date) -> String {
    return fechaEntregaReal >= fechaDevolucion ? "Devuelto" : "Prestado"
}

// Situación del usuario
func situacionUsuario(diasAtraso: Int) -> String {
    return diasAtraso > 10 ? "Suspendido" : "Habilitado"
}

// Estructura fila calendario
struct FilaCalendario {
    let dia: Int
    let fecha: Date
    let multaDia: Double
    let acumulado: Double
}

// Generar calendario
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

// Multa total
func calcularMultaTotal(calendario: [FilaCalendario]) -> Double {
    return calendario.last?.acumulado ?? 0.0
}

// MARK: - Ejecución
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
let estado = estadoLibro(fechaDevolucion: prestamo.fechaDevolucion, fechaEntregaReal: prestamo.fechaEntregaReal)
let situacion = situacionUsuario(diasAtraso: diasAtraso)

let formatter = DateFormatter()
formatter.dateFormat = "dd/MM/yyyy"
formatter.locale = Locale(identifier: "es_PE")

print("\n✅ Datos ingresados correctamente.")
print("Libro: \(prestamo.tituloLibro)")
print("Usuario: \(prestamo.tipoUsuario.rawValue)")
print("Días de atraso: \(diasAtraso)")
print("Estado libro: \(estado)")
print("Situación usuario: \(situacion)")

if diasAtraso > 0 {
    print("\nDía  Fecha        Multa día  Acumulado")
    for fila in calendario {
        print("  \(fila.dia)    \(formatter.string(from: fila.fecha))   \(String(format: "%.2f", fila.multaDia))       \(String(format: "%.2f", fila.acumulado))")
    }
    print("Multa total: S/ \(String(format: "%.2f", multaTotal))")
} else {
    print("\n✅ Sin multas. Libro entregado a tiempo.")
}
