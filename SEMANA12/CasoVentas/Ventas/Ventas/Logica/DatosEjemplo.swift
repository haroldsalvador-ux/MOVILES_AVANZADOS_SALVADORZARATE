//
//  DatosEjemplo.swift
//  Ventas
//
//  Datos iniciales para probar la app (solo si la base está vacía).
//  Vendedores de ejemplo: jperez y mrios, clave 123456.
//

import CoreData

enum DatosEjemplo {

    static func cargarSiHaceFalta() {
        let contexto = Datos.contexto
        let conteo = (try? contexto.count(for: Producto.fetchRequest())) ?? 0
        guard conteo == 0 else { return }

        func usuario(_ nombre: String, _ usuario: String) -> Usuario {
            let u = Usuario(context: contexto)
            u.nombre = nombre; u.usuario = usuario; u.clave = "123456"; u.rol = Rol.vendedor
            return u
        }
        func producto(_ nombre: String, _ categoria: String, _ precio: Double, _ stock: Int64) -> Producto {
            let p = Producto(context: contexto)
            p.nombre = nombre; p.categoria = categoria; p.precio = precio; p.stock = stock
            return p
        }
        func cliente(_ nombre: String, _ documento: String) -> Cliente {
            let c = Cliente(context: contexto)
            c.nombre = nombre; c.documento = documento
            return c
        }
        // Ventas pasadas: en ese momento los clientes eran Regular (sin descuento)
        func venta(haceDias: Int, _ vendedor: Usuario, _ cliente: Cliente, _ producto: Producto, _ cantidad: Int) {
            let montos = Calculo.resumen(precio: producto.precio, cantidad: cantidad, categoria: .regular)
            let v = Venta(context: contexto)
            let dia = Fechas.sumarDias(-haceDias, a: Fechas.inicioDelDia(Date()))
            v.fecha = Fechas.calendario.date(byAdding: .hour, value: 11, to: dia)
            v.cantidad = Int64(cantidad); v.precioUnitario = producto.precio
            v.descuento = montos.descuento; v.igv = montos.igv; v.total = montos.total
            v.vendedor = vendedor; v.cliente = cliente; v.producto = producto
        }

        let juan = usuario("Juan Pérez", "jperez")
        let marta = usuario("Marta Ríos", "mrios")

        _ = producto("Laptop", "Cómputo", 200, 40)
        _ = producto("Mouse", "Accesorios", 35, 60)
        let teclado = producto("Teclado", "Accesorios", 100, 25)
        _ = producto("Monitor", "Cómputo", 300, 15)
        let impresora = producto("Impresora", "Impresión", 800, 7)
        let proyector = producto("Proyector", "Cómputo", 1500, 3)
        _ = producto("Cable HDMI", "Accesorios", 15, 4)
        let audifonos = producto("Audífonos", "Audio", 60, 8)

        let andina = cliente("Comercial Andina SAC", "20512345678")   // VIP (7,080.00)
        let rosa = cliente("Rosa Díaz", "45678912")                   // Frecuente (4,720.00)
        _ = cliente("María López", "70123456")                         // Regular (sin compras)
        let carlos = cliente("Carlos Vega", "41234567")               // Regular (448.40)

        venta(haceDias: 6, juan, andina, proyector, 4)    // 6,000 + IGV = 7,080.00
        venta(haceDias: 4, marta, rosa, impresora, 5)     // 4,000 + IGV = 4,720.00
        venta(haceDias: 2, juan, carlos, teclado, 2)      //   200 + IGV =   236.00
        venta(haceDias: 1, marta, carlos, audifonos, 3)   //   180 + IGV =   212.40

        try? contexto.save()
    }
}
