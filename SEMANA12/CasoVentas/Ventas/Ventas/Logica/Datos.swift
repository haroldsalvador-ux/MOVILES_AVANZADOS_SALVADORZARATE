//
//  Datos.swift
//  Ventas
//
//  Lecturas y escrituras en Core Data (fetch requests con NSPredicate).
//

import UIKit
import CoreData

enum Periodo: Int {
    case todas, hoy, mes

    /// Fecha desde la que se cuentan las ventas (nil = todas)
    var desde: Date? {
        switch self {
        case .todas: return nil
        case .hoy: return Fechas.inicioDelDia(Date())
        case .mes: return Fechas.inicioDelMes(Date())
        }
    }
}

enum ErrorVenta: LocalizedError {
    case faltanDatos
    case cantidadInvalida
    case stockInsuficiente(disponible: Int64, producto: String)

    var errorDescription: String? {
        switch self {
        case .faltanDatos: return "Elige un cliente y un producto."
        case .cantidadInvalida: return "La cantidad debe ser mayor que cero."
        case .stockInsuficiente(let disponible, let producto):
            return "Solo hay \(disponible) unidades de \(producto). La venta no se registró."
        }
    }
}

enum Datos {

    static var contexto: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    // MARK: - Usuarios

    /// Usuario único sin distinguir mayúsculas: "usuario ==[c] %@"
    static func buscarUsuario(_ usuario: String) -> Usuario? {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "usuario ==[c] %@", usuario)
        request.fetchLimit = 1
        return (try? contexto.fetch(request))?.first
    }

    /// Devuelve el usuario solo si el usuario y la clave coinciden
    static func login(usuario: String, clave: String) -> Usuario? {
        guard let encontrado = buscarUsuario(usuario), encontrado.clave == clave else { return nil }
        return encontrado
    }

    static func registrarUsuario(nombre: String, usuario: String, clave: String, rol: String) throws -> Usuario {
        let nuevo = Usuario(context: contexto)
        nuevo.nombre = nombre
        nuevo.usuario = usuario
        nuevo.clave = clave
        nuevo.rol = rol
        try contexto.save()
        return nuevo
    }

    static func vendedores() -> [Usuario] {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "rol == %@", Rol.vendedor)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? contexto.fetch(request)) ?? []
    }

    // MARK: - Productos

    static func productos(texto: String = "", categoria: String? = nil) -> [Producto] {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        var filtros: [NSPredicate] = []
        if !texto.isEmpty { filtros.append(NSPredicate(format: "nombre CONTAINS[cd] %@", texto)) }
        if let categoria { filtros.append(NSPredicate(format: "categoria == %@", categoria)) }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? contexto.fetch(request)) ?? []
    }

    static func categorias() -> [String] {
        let nombres = productos().compactMap { $0.categoria }
        return Array(Set(nombres)).sorted()
    }

    /// Stock bajo: 5 unidades o menos
    static func productosConStockBajo() -> [Producto] {
        let request: NSFetchRequest<Producto> = Producto.fetchRequest()
        request.predicate = NSPredicate(format: "stock <= 5")
        request.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true)]
        return (try? contexto.fetch(request)) ?? []
    }

    // MARK: - Clientes

    static func clientes(texto: String = "") -> [Cliente] {
        let request: NSFetchRequest<Cliente> = Cliente.fetchRequest()
        if !texto.isEmpty { request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@", texto) }
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        return (try? contexto.fetch(request)) ?? []
    }

    /// Lo comprado: suma del total de las ventas NO anuladas del cliente
    static func totalComprado(_ cliente: Cliente) -> Double {
        let ventas = (cliente.ventas as? Set<Venta>) ?? []
        return Calculo.redondear(ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total })
    }

    static func categoria(de cliente: Cliente) -> CategoriaCliente {
        CategoriaCliente.desde(totalComprado: totalComprado(cliente))
    }

    // MARK: - Ventas

    /// vendedor: nil = todas (supervisor) · periodo · búsqueda por nombre del cliente
    static func ventas(de vendedor: Usuario?, periodo: Periodo = .todas, cliente texto: String = "") -> [Venta] {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        var filtros: [NSPredicate] = []
        if let vendedor { filtros.append(NSPredicate(format: "vendedor == %@", vendedor)) }
        if let desde = periodo.desde { filtros.append(NSPredicate(format: "fecha >= %@", desde as NSDate)) }
        if !texto.isEmpty { filtros.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", texto)) }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: filtros)
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        return (try? contexto.fetch(request)) ?? []
    }

    /// Ventas no anuladas entre dos fechas (para reportes)
    static func ventasValidas(desde: Date, hasta: Date) -> [Venta] {
        let request: NSFetchRequest<Venta> = Venta.fetchRequest()
        request.predicate = NSPredicate(format: "anulada == NO AND fecha >= %@ AND fecha < %@", desde as NSDate, hasta as NSDate)
        return (try? contexto.fetch(request)) ?? []
    }

    /// Suma solo las ventas no anuladas
    static func sumar(_ ventas: [Venta]) -> Double {
        Calculo.redondear(ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total })
    }

    /// Registra la venta: valida stock, calcula montos, baja el stock y guarda
    @discardableResult
    static func registrarVenta(vendedor: Usuario, cliente: Cliente?, producto: Producto?, cantidad: Int) throws -> Venta {
        guard let cliente, let producto else { throw ErrorVenta.faltanDatos }
        guard cantidad > 0 else { throw ErrorVenta.cantidadInvalida }
        guard Int64(cantidad) <= producto.stock else {
            throw ErrorVenta.stockInsuficiente(disponible: producto.stock, producto: producto.nombre ?? "")
        }
        let montos = Calculo.resumen(precio: producto.precio, cantidad: cantidad, categoria: categoria(de: cliente))
        let venta = Venta(context: contexto)
        venta.fecha = Date()
        venta.cantidad = Int64(cantidad)
        venta.precioUnitario = producto.precio
        venta.descuento = montos.descuento
        venta.igv = montos.igv
        venta.total = montos.total
        venta.anulada = false
        venta.vendedor = vendedor      // quién la registró (relación con Usuario)
        venta.cliente = cliente
        venta.producto = producto
        producto.stock -= Int64(cantidad)
        try contexto.save()
        return venta
    }

    /// Anular: exige motivo, marca la venta y devuelve el stock
    static func anular(_ venta: Venta, motivo: String) throws {
        let texto = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !texto.isEmpty, !venta.anulada else { return }
        venta.anulada = true
        venta.motivoAnulacion = texto
        venta.producto?.stock += venta.cantidad
        try contexto.save()
    }

    // MARK: - Borrar

    /// Con la delete rule Deny, Core Data no deja guardar si el objeto tiene ventas.
    /// Devuelve false y deshace el cambio para avisar con una alerta.
    static func borrar(_ objeto: NSManagedObject) -> Bool {
        contexto.delete(objeto)
        do {
            try contexto.save()
            return true
        } catch {
            contexto.rollback()
            return false
        }
    }

    static func guardar() throws {
        if contexto.hasChanges { try contexto.save() }
    }
}

enum Fechas {
    static var calendario: Calendar {
        var c = Calendar(identifier: .gregorian)
        c.locale = Locale(identifier: "es_PE")
        return c
    }

    static func inicioDelDia(_ fecha: Date) -> Date { calendario.startOfDay(for: fecha) }

    static func inicioDelMes(_ fecha: Date) -> Date {
        calendario.date(from: calendario.dateComponents([.year, .month], from: fecha))!
    }

    static func sumarDias(_ dias: Int, a fecha: Date) -> Date {
        calendario.date(byAdding: .day, value: dias, to: fecha)!
    }
}
