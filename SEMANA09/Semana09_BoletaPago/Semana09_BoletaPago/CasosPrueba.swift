//
//  CasosPrueba.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import Foundation

// Un caso de prueba del enunciado: los datos de entrada y, si lo trae, el neto esperado
struct CasoPrueba: Identifiable {
    let id = UUID()
    let nombre: String
    let datos: DatosTrabajador
    let netoEsperado: Decimal?
}

// Array con los casos que se pueden cargar desde la pantalla
let casosPrueba: [CasoPrueba] = [
    // Caso 1 · Sin hijos, ONP, mes completo
    CasoPrueba(nombre: "Caso 1",
               datos: DatosTrabajador(sueldoBasico: 2500, diasLaborados: 30, tieneHijos: false, sistema: .onp),
               netoEsperado: Decimal(string: "2175.00"))
]
