//
//  Formato.swift
//  Ventas
//

import Foundation

enum Formato {
    private static let numero: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.locale = Locale(identifier: "en_US")   // 1,050.00
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()

    static func soles(_ valor: Double) -> String {
        "S/ " + (numero.string(from: NSNumber(value: valor)) ?? "0.00")
    }

    private static let fechaHora: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_PE")
        f.dateFormat = "dd/MM/yyyy HH:mm"
        return f
    }()

    private static let diaCorto: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "es_PE")
        f.dateFormat = "EEE d"
        return f
    }()

    static func fecha(_ fecha: Date?) -> String { fecha.map { fechaHora.string(from: $0) } ?? "" }
    static func dia(_ fecha: Date) -> String { diaCorto.string(from: fecha) }

    /// 7080 → "7.1k" (para las barras del gráfico)
    static func corto(_ valor: Double) -> String {
        valor >= 1000 ? String(format: "%.1fk", valor / 1000) : String(format: "%.0f", valor)
    }

    static func iniciales(_ nombre: String) -> String {
        nombre.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined().uppercased()
    }
}
