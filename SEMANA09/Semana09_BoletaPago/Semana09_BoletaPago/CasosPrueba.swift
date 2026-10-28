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
               netoEsperado: Decimal(string: "2175.00")),
    // Caso 2 · Con hijos y días incompletos
    CasoPrueba(nombre: "Caso 2",
               datos: DatosTrabajador(sueldoBasico: 1800, diasLaborados: 27, tieneHijos: true, sistema: .onp),
               netoEsperado: Decimal(string: "1516.41")),
    // Caso 3 · AFP, horas extras y adelanto
    CasoPrueba(nombre: "Caso 3",
               datos: DatosTrabajador(sueldoBasico: 3000, diasLaborados: 30, tieneHijos: true, sistema: .afp,
                                      nombreAFP: "AFP Ejemplo", horas25: 4, horas35: 4, adelantos: 200),
               netoEsperado: Decimal(string: "2631.73")),
    // Caso 4 · Evaluación (sin respuesta: lo revisa el docente)
    CasoPrueba(nombre: "Caso 4",
               datos: DatosTrabajador(sueldoBasico: 4200, diasLaborados: 24, tieneHijos: true, sistema: .afp,
                                      nombreAFP: "AFP Ejemplo", horas25: 2, horas35: 2, adelantos: 100),
               netoEsperado: nil),
    // Caso propio · sueldo de una oferta laboral real (Computrabajo, consultada el 28/10/2026), AFP Habitat
    CasoPrueba(nombre: "Propio",
               datos: DatosTrabajador(sueldoBasico: 1700, diasLaborados: 30, tieneHijos: false, sistema: .afp,
                                      nombreAFP: "Habitat"),
               netoEsperado: nil)
]
