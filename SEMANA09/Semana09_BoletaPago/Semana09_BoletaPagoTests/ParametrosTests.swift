//
//  ParametrosTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// Verifica que los parámetros tengan los valores del enunciado y de la SBS
final class ParametrosTests: XCTestCase {

    func testParametrosLegales() {
        XCTAssertEqual(Parametros.rmv, 1230)
        XCTAssertEqual(Parametros.tasaAsignacionFamiliar, d("0.10"))
        XCTAssertEqual(Parametros.tasaONP, d("0.13"))
        XCTAssertEqual(Parametros.tasaEsSalud, d("0.09"))
        XCTAssertEqual(Parametros.recargoHoras25, d("1.25"))
        XCTAssertEqual(Parametros.recargoHoras35, d("1.35"))
        XCTAssertEqual(Parametros.diasDelMes, 30)
        XCTAssertEqual(Parametros.horasPorDia, 8)
    }

    func testDiccionarioTieneTodasLasAFP() {
        XCTAssertEqual(Parametros.tasasAFP.count, 5)
        // Cada nombre del Picker debe existir en el diccionario
        for nombre in Parametros.nombresAFP {
            XCTAssertNotNil(Parametros.tasasAFP[nombre], "Falta la AFP \(nombre) en el diccionario")
        }
    }

    func testTasasAFPEjemploDelEnunciado() {
        let tasas = Parametros.tasasAFP["AFP Ejemplo"]!
        XCTAssertEqual(tasas.fondo, d("0.10"))
        XCTAssertEqual(tasas.comision, d("0.016"))
        XCTAssertEqual(tasas.seguro, d("0.0135"))
    }

    func testTasasAFPRealesDeLaSBS() {
        XCTAssertEqual(Parametros.tasasAFP["Habitat"]!.comision, d("0.0147"))
        XCTAssertEqual(Parametros.tasasAFP["Integra"]!.comision, d("0.0155"))
        XCTAssertEqual(Parametros.tasasAFP["Prima"]!.comision, d("0.016"))
        XCTAssertEqual(Parametros.tasasAFP["Profuturo"]!.comision, d("0.0169"))
        for nombre in ["Habitat", "Integra", "Prima", "Profuturo"] {
            XCTAssertEqual(Parametros.tasasAFP[nombre]!.fondo, d("0.10"))
            XCTAssertEqual(Parametros.tasasAFP[nombre]!.seguro, d("0.0137"))
        }
    }
}
