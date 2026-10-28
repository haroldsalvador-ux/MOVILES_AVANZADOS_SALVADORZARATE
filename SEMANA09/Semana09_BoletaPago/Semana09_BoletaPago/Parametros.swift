//
//  Parametros.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import Foundation

// Tasas de una AFP: las tres se aplican sobre el total de remuneraciones
struct TasasAFP {
    let fondo: Decimal      // aporte obligatorio al fondo de pensiones
    let comision: Decimal   // comisión sobre flujo
    let seguro: Decimal     // prima de seguros
}

// Todos los parámetros están en un solo lugar: ninguna fórmula lleva números "escritos a mano"
enum Parametros {
    // RMV vigente desde el 1 de octubre de 2026 (dato del enunciado)
    static let rmv: Decimal = 1230
    // Ley 25129: asignación familiar = 10% de la RMV
    static let tasaAsignacionFamiliar = Decimal(string: "0.10")!
    // D.L. 19990: aporte a la ONP
    static let tasaONP = Decimal(string: "0.13")!
    // Ley 26790: aporte a EsSalud (lo paga el empleador)
    static let tasaEsSalud = Decimal(string: "0.09")!
    // Recargos de sobretiempo
    static let recargoHoras25 = Decimal(string: "1.25")!
    static let recargoHoras35 = Decimal(string: "1.35")!
    // Mes de 30 días y jornada de 8 horas
    static let diasDelMes: Decimal = 30
    static let horasPorDia: Decimal = 8

    // Diccionario con las tasas de cada AFP.
    // "AFP Ejemplo" es la del enunciado (solo para los casos de prueba).
    // Las demás son las publicadas por la SBS para el mes de devengue 2026-10
    // (consultado el 28/10/2026).
    static let tasasAFP: [String: TasasAFP] = [
        "AFP Ejemplo": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.016")!, seguro: Decimal(string: "0.0135")!),
        "Habitat": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0147")!, seguro: Decimal(string: "0.0137")!),
        "Integra": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0155")!, seguro: Decimal(string: "0.0137")!),
        "Prima": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.016")!, seguro: Decimal(string: "0.0137")!),
        "Profuturo": TasasAFP(fondo: Decimal(string: "0.10")!, comision: Decimal(string: "0.0169")!, seguro: Decimal(string: "0.0137")!)
    ]

    // Nombres ordenados para mostrarlos en el Picker
    static let nombresAFP = ["AFP Ejemplo", "Habitat", "Integra", "Prima", "Profuturo"]
}
