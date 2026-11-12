//
//  Calculo.swift
//  Ventas
//
//  Reglas de negocio: categoría del cliente, descuento, IGV y total.
//

import Foundation

/// Categoría del cliente. Se calcula con lo comprado (ventas no anuladas); no se guarda.
enum CategoriaCliente: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"

    /// Regular < 1,000 · Frecuente desde 1,000 · VIP desde 5,000
    static func desde(totalComprado: Double) -> CategoriaCliente {
        if totalComprado >= 5000 { return .vip }
        if totalComprado >= 1000 { return .frecuente }
        return .regular
    }

    /// VIP tiene 10 % de descuento; los demás 0 %.
    var porcentajeDescuento: Double { self == .vip ? 0.10 : 0 }
}

/// Montos de una venta, ya redondeados a 2 decimales.
struct ResumenVenta {
    let subtotal: Double
    let descuento: Double
    let igv: Double
    let total: Double
}

enum Calculo {
    static let tasaIGV = 0.18

    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    /// subtotal = precio × cantidad · descuento según categoría
    /// IGV = 18 % de (subtotal − descuento) · total = subtotal − descuento + IGV
    static func resumen(precio: Double, cantidad: Int, categoria: CategoriaCliente) -> ResumenVenta {
        let subtotal = redondear(precio * Double(cantidad))
        let descuento = redondear(subtotal * categoria.porcentajeDescuento)
        let igv = redondear((subtotal - descuento) * tasaIGV)
        let total = redondear(subtotal - descuento + igv)
        return ResumenVenta(subtotal: subtotal, descuento: descuento, igv: igv, total: total)
    }
}
