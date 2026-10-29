//
//  DescuentosTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Bloque 2 (descuentos), bloque 3 (EsSalud) y neto a pagar
final class DescuentosTests: XCTestCase {

    func testONPEsTrecePorcientoDelTotal() {
        let boleta = Boleta(datos: datos(sueldo: "2500", sistema: .onp))
        XCTAssertEqual(boleta.onp, d("325"))
    }

    func testONPSeCalculaSobreElTotalConAsignacion() {
        // (1,620 + 123) × 13% = 226.59
        let boleta = Boleta(datos: datos(sueldo: "1800", dias: 27, hijos: true, sistema: .onp))
        XCTAssertEqual(boleta.onp, d("226.59"))
    }

    func testConONPNoHayDescuentosDeAFP() {
        let boleta = Boleta(datos: datos(sueldo: "2500", sistema: .onp))
        XCTAssertNil(boleta.tasasAFP)
        XCTAssertEqual(boleta.afpFondo, 0)
        XCTAssertEqual(boleta.afpComision, 0)
        XCTAssertEqual(boleta.afpSeguro, 0)
    }

    func testConAFPNoHayDescuentoDeONP() {
        let boleta = Boleta(datos: datos(sueldo: "2500", sistema: .afp))
        XCTAssertEqual(boleta.onp, 0)
    }

    func testDescuentosAFPEjemplo() {
        // Total 3,253: fondo 325.30 · comisión 52.048 → 52.05 · seguro 43.9155 → 43.92
        let boleta = Boleta(datos: datos(sueldo: "3000", hijos: true, sistema: .afp, horas25: "4", horas35: "4"))
        XCTAssertEqual(boleta.afpFondo, d("325.30"))
        XCTAssertEqual(boleta.afpComision, d("52.05"))
        XCTAssertEqual(boleta.afpSeguro, d("43.92"))
    }

    func testDescuentosConAFPRealHabitat() {
        // 1,700: fondo 170.00 · comisión 1.47% = 24.99 · seguro 1.37% = 23.29
        let boleta = Boleta(datos: datos(sueldo: "1700", sistema: .afp, afp: "Habitat"))
        XCTAssertEqual(boleta.afpFondo, d("170"))
        XCTAssertEqual(boleta.afpComision, d("24.99"))
        XCTAssertEqual(boleta.afpSeguro, d("23.29"))
    }

    func testCadaAFPUsaSuPropiaComision() {
        let integra = Boleta(datos: datos(sueldo: "2000", sistema: .afp, afp: "Integra"))
        let profuturo = Boleta(datos: datos(sueldo: "2000", sistema: .afp, afp: "Profuturo"))
        XCTAssertEqual(integra.afpComision, d("31"))      // 2,000 × 1.55%
        XCTAssertEqual(profuturo.afpComision, d("33.8"))  // 2,000 × 1.69%
    }

    func testAdelantosSeRestanTalCual() {
        let boleta = Boleta(datos: datos(sueldo: "2500", adelantos: "200"))
        XCTAssertEqual(boleta.adelantos, d("200"))
        XCTAssertEqual(boleta.totalDescuentos, d("525"))  // 325 de ONP + 200
    }

    func testArrayDeDescuentosEnOrden() {
        let boleta = Boleta(datos: datos(sueldo: "2500"))
        XCTAssertEqual(boleta.descuentos.map(\.nombre),
                       ["ONP", "AFP fondo", "AFP comisión", "AFP seguro", "Adelantos"])
    }

    func testTotalDescuentosSumaPensionYAdelantos() {
        // 325.30 + 52.05 + 43.92 + 200 = 621.27
        let boleta = Boleta(datos: datos(sueldo: "3000", hijos: true, sistema: .afp,
                                         horas25: "4", horas35: "4", adelantos: "200"))
        XCTAssertEqual(boleta.totalDescuentos, d("621.27"))
    }

    func testNetoEsTotalMenosDescuentos() {
        let boleta = Boleta(datos: datos(sueldo: "2500"))
        XCTAssertEqual(boleta.netoAPagar, boleta.totalRemuneraciones - boleta.totalDescuentos)
        XCTAssertEqual(boleta.netoAPagar, d("2175"))
    }

    func testEsSaludEsNuevePorCiento() {
        let boleta = Boleta(datos: datos(sueldo: "2500"))
        XCTAssertEqual(boleta.esSalud, d("225"))
        XCTAssertEqual(boleta.aportaciones.map(\.nombre), ["EsSalud (9%)"])
    }

    func testEsSaludNoSeDescuentaAlTrabajador() {
        let boleta = Boleta(datos: datos(sueldo: "2500"))
        XCTAssertFalse(boleta.descuentos.contains { $0.nombre.contains("EsSalud") })
        XCTAssertEqual(boleta.totalDescuentos, d("325"))
    }
}
