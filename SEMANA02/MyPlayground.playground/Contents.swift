import Foundation

//tipo de usuario
enum TipoUsuario:String {
    case alumno = "Amuno"
    case docente = "Docente"
    case administrador = "Administrador"
}

//entidad prestamo

struct Prestamo {
    let tituloLibro: String
    let tipoUsuario: TipoUsuario
    let fechaPrestamo: Date
    let fechaDevolucion: Date
}

//ingreso de datos

func leerFecha(_ mensaje: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "es_PE")
    
while true {
        print(mensaje, terminator: " ")
        if let input = readLine(), let fecha = formatter.date(from: input) {
            return fecha
        }
        print("Fecha inválida. Usa el formato dd/MM/yyyy")
    }
}

func leerTipoUsuario() -> TipoUsuario {
    print("Tipo de usuario:")
    print("1. Alumno")
    print("2. Docente")
    print("3. Administrador")

    while true {
        print("Selecciona (1-3):", terminator: " ")
        if let input = readLine() {
            switch input {
            case "1": return .alumno
            case "2": return .docente
            case "3": return .administrador
            default: print("Opción inválida. Intenta de nuevo.")
            }
        }
    }
}

func ingresarDatos() -> Prestamo {
    print("=== SISTEMA DE PRÉSTAMO DE LIBROS ===\n")

    print("Título del libro:", terminator: " ")
    let titulo = readLine() ?? "Sin título"

    let tipo = leerTipoUsuario()

    let fechaPrestamo = leerFecha("Fecha de préstamo (dd/MM/yyyy):")
    let fechaDevolucion = leerFecha("Fecha de devolución (dd/MM/yyyy):")

    return Prestamo(
        tituloLibro: titulo,
        tipoUsuario: tipo,
        fechaPrestamo: fechaPrestamo,
        fechaDevolucion: fechaDevolucion
    )
}

// Ejecución
let prestamo = ingresarDatos()
print("\nDatos ingresados correctamente.")
print("Libro: \(prestamo.tituloLibro)")
print("Usuario: \(prestamo.tipoUsuario.rawValue)")
