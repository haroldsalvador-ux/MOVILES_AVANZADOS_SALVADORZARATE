//
//  RemuneracionesTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Bloque 1 de la boleta: lo que gana el trabajador
final class RemuneracionesTests: XCTestCase {

    func testSueldoComputableMesCompleto() {
        let boleta = Boleta(datos: datos(sueldo: "2500", dias: 30))
        XCTAssertEqual(boleta.sueldoComputable, d("2500"))
    }

    func testSueldoComputableSeProrrateaPorDias() {
        // 1,800 ÷ 30 × 27 = 1,620.00
        let boleta = Boleta(datos: datos(sueldo: "1800", dias: 27))
        XCTAssertEqual(boleta.sueldoComputable, d("1620"))
    }

    func testSueldoComputableSeRedondea() {
        // 1,000 ÷ 30 × 7 = 233.333… → 233.33
        let boleta = Boleta(datos: datos(sueldo: "1000", dias: 7))
        XCTAssertEqual(boleta.sueldoComputable, d("233.33"))
    }

    func testAsignacionFamiliarConHijos() {
        let boleta = Boleta(datos: datos(sueldo: "1800", hijos: true))
        XCTAssertEqual(boleta.asignacionFamiliar, d("123"))
    }

    func testSinHijosNoHayAsignacionFamiliar() {
        let boleta = Boleta(datos: datos(sueldo: "1800", hijos: false))
        XCTAssertEqual(boleta.asignacionFamiliar, 0)
    }

    func testAsignacionFamiliarNoSeProrrateaPorDias() {
        let boleta = Boleta(datos: datos(sueldo: "1800", dias: 10, hijos: true))
        XCTAssertEqual(boleta.asignacionFamiliar, d("123"))
    }

    func testValorHora() {
        // 3,000 ÷ 30 ÷ 8 = 12.50
        let boleta = Boleta(datos: datos(sueldo: "3000"))
        XCTAssertEqual(boleta.valorHora, d("12.5"))
    }

    func testHorasExtrasAl25() {
        // 12.50 × 1.25 × 4 = 62.50
        let boleta = Boleta(datos: datos(sueldo: "3000", horas25: "4"))
        XCTAssertEqual(boleta.horasExtras25, d("62.50"))
    }

    func testHorasExtrasAl35() {
        // 12.50 × 1.35 × 4 = 67.50
        let boleta = Boleta(datos: datos(sueldo: "3000", horas35: "4"))
        XCTAssertEqual(boleta.horasExtras35, d("67.50"))
    }

    func testSinHorasExtrasEsCero() {
        let boleta = Boleta(datos: datos(sueldo: "3000"))
        XCTAssertEqual(boleta.horasExtras25, 0)
        XCTAssertEqual(boleta.horasExtras35, 0)
    }

    func testTotalRemuneracionesSumaLosCuatroConceptos() {
        // 3,000 + 123 + 62.50 + 67.50 = 3,253.00
        let boleta = Boleta(datos: datos(sueldo: "3000", hijos: true, horas25: "4", horas35: "4"))
        XCTAssertEqual(boleta.totalRemuneraciones, d("3253"))
    }

    func testArrayDeRemuneracionesEnOrden() {
        let boleta = Boleta(datos: datos(sueldo: "3000", hijos: true, horas25: "4", horas35: "4"))
        XCTAssertEqual(boleta.remuneraciones.map(\.nombre),
                       ["Sueldo computable", "Asignación familiar", "Horas extras 25%", "Horas extras 35%"])
        XCTAssertEqual(boleta.remuneraciones.map(\.monto), [d("3000"), d("123"), d("62.5"), d("67.5")])
    }
}
