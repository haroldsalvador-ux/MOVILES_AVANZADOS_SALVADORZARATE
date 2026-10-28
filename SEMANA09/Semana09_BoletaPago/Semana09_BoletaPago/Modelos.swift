//
//  Modelos.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import Foundation

enum SistemaPensiones: String, CaseIterable {
    case onp = "ONP"
    case afp = "AFP"
}

// Datos que el usuario ingresa en el formulario (ya validados y convertidos a número)
struct DatosTrabajador {
    var sueldoBasico: Decimal
    var diasLaborados: Int
    var tieneHijos: Bool
    var sistema: SistemaPensiones
    var nombreAFP: String = "AFP Ejemplo"
    var horas25: Decimal = 0
    var horas35: Decimal = 0
    var adelantos: Decimal = 0
}

// Una línea de la boleta: nombre del concepto y su monto
struct Concepto: Identifiable {
    let id = UUID()
    let nombre: String
    let monto: Decimal
}

// Encabezado de la boleta (reto). Siempre con datos ficticios
struct Encabezado {
    var razonSocial: String
    var trabajador: String
}
