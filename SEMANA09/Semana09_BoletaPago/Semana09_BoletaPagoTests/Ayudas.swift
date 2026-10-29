//
//  Ayudas.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import Foundation
@testable import Semana09_BoletaPago

// Crea un Decimal exacto a partir de texto (evita errores de Double en los montos esperados)
func d(_ texto: String) -> Decimal {
    Decimal(string: texto)!
}

// Datos base para armar boletas en las pruebas
func datos(sueldo: String, dias: Int = 30, hijos: Bool = false, sistema: SistemaPensiones = .onp,
           afp: String = "AFP Ejemplo", horas25: String = "0", horas35: String = "0",
           adelantos: String = "0") -> DatosTrabajador {
    DatosTrabajador(sueldoBasico: d(sueldo), diasLaborados: dias, tieneHijos: hijos, sistema: sistema,
                    nombreAFP: afp, horas25: d(horas25), horas35: d(horas35), adelantos: d(adelantos))
}
