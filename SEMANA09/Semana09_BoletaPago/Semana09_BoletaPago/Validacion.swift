//
//  Validacion.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import Foundation

// Convierte el texto de un TextField en número. Acepta coma o punto como separador decimal.
// Devuelve nil si el texto no es un número válido (por ejemplo "12abc" o "").
func convertirNumero(_ texto: String) -> Decimal? {
    let limpio = texto.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: ".")
    guard limpio.wholeMatch(of: /\d+(\.\d+)?/) != nil else { return nil }
    return Decimal(string: limpio)
}

// Resultado de validar: o datos listos para calcular, o un mensaje de error
enum ResultadoValidacion {
    case valido(DatosTrabajador)
    case invalido(String)
}

func validar(sueldo: String, dias: String, tieneHijos: Bool, sistema: SistemaPensiones,
             nombreAFP: String, horas25: String, horas35: String, adelantos: String) -> ResultadoValidacion {
    guard let sueldoBasico = convertirNumero(sueldo), sueldoBasico > 0 else {
        return .invalido("El sueldo básico debe ser un número mayor que cero.")
    }
    guard let diasLaborados = Int(dias.trimmingCharacters(in: .whitespaces)), (1...30).contains(diasLaborados) else {
        return .invalido("Los días laborados deben ser un número entero entre 1 y 30.")
    }
    guard let h25 = convertirNumero(horas25.isEmpty ? "0" : horas25) else {
        return .invalido("Las horas extras al 25% deben ser un número mayor o igual a cero.")
    }
    guard let h35 = convertirNumero(horas35.isEmpty ? "0" : horas35) else {
        return .invalido("Las horas extras al 35% deben ser un número mayor o igual a cero.")
    }
    guard let adelanto = convertirNumero(adelantos.isEmpty ? "0" : adelantos) else {
        return .invalido("Los adelantos deben ser un monto mayor o igual a cero.")
    }

    let datos = DatosTrabajador(sueldoBasico: sueldoBasico, diasLaborados: diasLaborados,
                                tieneHijos: tieneHijos, sistema: sistema, nombreAFP: nombreAFP,
                                horas25: h25, horas35: h35, adelantos: adelanto)
    let boleta = Boleta(datos: datos)
    if boleta.netoAPagar < 0 {
        return .invalido("Los descuentos superan las remuneraciones: revisa el monto de los adelantos.")
    }
    return .valido(datos)
}
