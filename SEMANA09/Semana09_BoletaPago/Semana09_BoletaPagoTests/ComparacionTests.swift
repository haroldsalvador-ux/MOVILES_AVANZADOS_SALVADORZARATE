//
//  ComparacionTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Reto: ONP y AFP lado a lado con los mismos datos
final class ComparacionTests: XCTestCase {

    let caso3 = datos(sueldo: "3000", hijos: true, sistema: .afp, horas25: "4", horas35: "4", adelantos: "200")

    func testCalculaLaMismaBoletaConONPyConAFP() {
        let vista = ComparacionView(datos: caso3)
        XCTAssertEqual(vista.conONP.datos.sistema, .onp)
        XCTAssertEqual(vista.conAFP.datos.sistema, .afp)
        // Solo cambia el sistema: el total de remuneraciones es el mismo
        XCTAssertEqual(vista.conONP.totalRemuneraciones, vista.conAFP.totalRemuneraciones)
        XCTAssertEqual(vista.conONP.netoAPagar, d("2630.11"))
        XCTAssertEqual(vista.conAFP.netoAPagar, d("2631.73"))
    }

    func testConclusionDiceCualDejaMasDinero() {
        let vista = ComparacionView(datos: caso3)
        XCTAssertEqual(vista.conclusion, "Este mes, con AFP Ejemplo recibe S/ 1.62 más que con la ONP.")
    }

    func testConclusionCuandoGanaLaONP() {
        // Con Profuturo (comisión más alta) la ONP deja más: 13% < 10% + 1.69% + 1.37%
        let vista = ComparacionView(datos: datos(sueldo: "2000", sistema: .afp, afp: "Profuturo"))
        XCTAssertTrue(vista.conclusion.hasPrefix("Este mes, con la ONP recibe"))
    }
}
