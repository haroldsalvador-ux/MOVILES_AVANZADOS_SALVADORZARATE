//
//  CasosPruebaTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Los 4 casos del enunciado, concepto por concepto (control cruzado con el Excel)
final class CasosPruebaTests: XCTestCase {

    func testCaso1SinHijosONPMesCompleto() {
        let boleta = Boleta(datos: datos(sueldo: "2500", dias: 30, hijos: false, sistema: .onp))
        XCTAssertEqual(boleta.sueldoComputable, d("2500.00"))
        XCTAssertEqual(boleta.totalRemuneraciones, d("2500.00"))
        XCTAssertEqual(boleta.onp, d("325.00"))
        XCTAssertEqual(boleta.netoAPagar, d("2175.00"))
        XCTAssertEqual(boleta.esSalud, d("225.00"))
    }

    func testCaso2ConHijosYDiasIncompletos() {
        let boleta = Boleta(datos: datos(sueldo: "1800", dias: 27, hijos: true, sistema: .onp))
        XCTAssertEqual(boleta.sueldoComputable, d("1620.00"))
        XCTAssertEqual(boleta.asignacionFamiliar, d("123.00"))
        XCTAssertEqual(boleta.totalRemuneraciones, d("1743.00"))
        XCTAssertEqual(boleta.onp, d("226.59"))
        XCTAssertEqual(boleta.netoAPagar, d("1516.41"))
        XCTAssertEqual(boleta.esSalud, d("156.87"))
    }

    func testCaso3AFPHorasExtrasYAdelanto() {
        let boleta = Boleta(datos: datos(sueldo: "3000", dias: 30, hijos: true, sistema: .afp,
                                         horas25: "4", horas35: "4", adelantos: "200"))
        XCTAssertEqual(boleta.sueldoComputable, d("3000.00"))
        XCTAssertEqual(boleta.asignacionFamiliar, d("123.00"))
        XCTAssertEqual(boleta.horasExtras25, d("62.50"))
        XCTAssertEqual(boleta.horasExtras35, d("67.50"))
        XCTAssertEqual(boleta.totalRemuneraciones, d("3253.00"))
        XCTAssertEqual(boleta.afpFondo, d("325.30"))
        XCTAssertEqual(boleta.afpComision, d("52.05"))
        XCTAssertEqual(boleta.afpSeguro, d("43.92"))
        XCTAssertEqual(boleta.adelantos, d("200.00"))
        XCTAssertEqual(boleta.totalDescuentos, d("621.27"))
        XCTAssertEqual(boleta.netoAPagar, d("2631.73"))
        XCTAssertEqual(boleta.esSalud, d("292.77"))
    }

    func testCaso4Evaluacion() {
        // Mismo resultado que la hoja Casos del Excel
        let boleta = Boleta(datos: datos(sueldo: "4200", dias: 24, hijos: true, sistema: .afp,
                                         horas25: "2", horas35: "2", adelantos: "100"))
        XCTAssertEqual(boleta.sueldoComputable, d("3360.00"))
        XCTAssertEqual(boleta.asignacionFamiliar, d("123.00"))
        XCTAssertEqual(boleta.horasExtras25, d("43.75"))
        XCTAssertEqual(boleta.horasExtras35, d("47.25"))
        XCTAssertEqual(boleta.totalRemuneraciones, d("3574.00"))
        XCTAssertEqual(boleta.afpFondo, d("357.40"))
        XCTAssertEqual(boleta.afpComision, d("57.18"))
        XCTAssertEqual(boleta.afpSeguro, d("48.25"))
        XCTAssertEqual(boleta.totalDescuentos, d("562.83"))
        XCTAssertEqual(boleta.netoAPagar, d("3011.17"))
        XCTAssertEqual(boleta.esSalud, d("321.66"))
    }

    func testCasoPropioOfertaReal() {
        let boleta = Boleta(datos: datos(sueldo: "1700", sistema: .afp, afp: "Habitat"))
        XCTAssertEqual(boleta.totalDescuentos, d("218.28"))
        XCTAssertEqual(boleta.netoAPagar, d("1481.72"))
    }

    func testCasosCargablesCoincidenConElEnunciado() {
        XCTAssertEqual(casosPrueba.map(\.nombre), ["Caso 1", "Caso 2", "Caso 3", "Caso 4", "Propio"])
        for caso in casosPrueba {
            if let esperado = caso.netoEsperado {
                XCTAssertEqual(Boleta(datos: caso.datos).netoAPagar, esperado, caso.nombre)
            }
        }
    }
}
