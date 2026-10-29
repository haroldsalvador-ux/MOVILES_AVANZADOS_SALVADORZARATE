//
//  ValidacionTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Si los datos no son válidos, la app muestra un mensaje claro y no calcula
final class ValidacionTests: XCTestCase {

    // Llama a validar() con datos correctos, cambiando solo lo que se indique
    func validarCon(sueldo: String = "2500", dias: String = "30", horas25: String = "0",
                    horas35: String = "0", adelantos: String = "0") -> ResultadoValidacion {
        validar(sueldo: sueldo, dias: dias, tieneHijos: false, sistema: .onp, nombreAFP: "AFP Ejemplo",
                horas25: horas25, horas35: horas35, adelantos: adelantos)
    }

    func mensaje(_ resultado: ResultadoValidacion) -> String? {
        if case .invalido(let texto) = resultado { return texto }
        return nil
    }

    // MARK: - convertirNumero

    func testConvierteNumerosConPuntoOComa() {
        XCTAssertEqual(convertirNumero("2500"), d("2500"))
        XCTAssertEqual(convertirNumero("2500.50"), d("2500.5"))
        XCTAssertEqual(convertirNumero("2500,50"), d("2500.5"))
        XCTAssertEqual(convertirNumero(" 200 "), d("200"))
    }

    func testRechazaTextoQueNoEsNumero() {
        XCTAssertNil(convertirNumero(""))
        XCTAssertNil(convertirNumero("abc"))
        XCTAssertNil(convertirNumero("12abc"))
        XCTAssertNil(convertirNumero("-5"))
        XCTAssertNil(convertirNumero("1.2.3"))
    }

    // MARK: - validar

    func testDatosCorrectosSonValidos() {
        guard case .valido(let datos) = validarCon(horas25: "4", adelantos: "100") else {
            return XCTFail("Debió ser válido")
        }
        XCTAssertEqual(datos.sueldoBasico, d("2500"))
        XCTAssertEqual(datos.diasLaborados, 30)
        XCTAssertEqual(datos.horas25, d("4"))
        XCTAssertEqual(datos.adelantos, d("100"))
    }

    func testSueldoDebeSerMayorQueCero() {
        let esperado = "El sueldo básico debe ser un número mayor que cero."
        XCTAssertEqual(mensaje(validarCon(sueldo: "0")), esperado)
        XCTAssertEqual(mensaje(validarCon(sueldo: "")), esperado)
        XCTAssertEqual(mensaje(validarCon(sueldo: "mil")), esperado)
    }

    func testDiasDebenEstarEntre1y30() {
        let esperado = "Los días laborados deben ser un número entero entre 1 y 30."
        XCTAssertEqual(mensaje(validarCon(dias: "0")), esperado)
        XCTAssertEqual(mensaje(validarCon(dias: "31")), esperado)
        XCTAssertEqual(mensaje(validarCon(dias: "15.5")), esperado)
        XCTAssertNil(mensaje(validarCon(dias: "1")))
        XCTAssertNil(mensaje(validarCon(dias: "30")))
    }

    func testHorasExtrasNoPuedenSerNegativas() {
        XCTAssertEqual(mensaje(validarCon(horas25: "-2")),
                       "Las horas extras al 25% deben ser un número mayor o igual a cero.")
        XCTAssertEqual(mensaje(validarCon(horas35: "-2")),
                       "Las horas extras al 35% deben ser un número mayor o igual a cero.")
    }

    func testAdelantosNoPuedenSerNegativos() {
        XCTAssertEqual(mensaje(validarCon(adelantos: "-100")),
                       "Los adelantos deben ser un monto mayor o igual a cero.")
    }

    func testCamposOpcionalesVaciosCuentanComoCero() {
        guard case .valido(let datos) = validarCon(horas25: "", horas35: "", adelantos: "") else {
            return XCTFail("Debió ser válido")
        }
        XCTAssertEqual(datos.horas25, 0)
        XCTAssertEqual(datos.horas35, 0)
        XCTAssertEqual(datos.adelantos, 0)
    }

    func testAdelantoMayorQueElSueldoNoSeCalcula() {
        XCTAssertEqual(mensaje(validarCon(sueldo: "1000", adelantos: "5000")),
                       "Los descuentos superan las remuneraciones: revisa el monto de los adelantos.")
    }
}
