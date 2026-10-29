//
//  RedondeoYFormatoTests.swift
//  Semana09_BoletaPagoTests
//
//  Created by Harold Salvador Zarate on 29/10/26.
//

import XCTest
@testable import Semana09_BoletaPago

// redondear() debe comportarse como REDONDEAR(x; 2) de Excel y formatear() como la boleta
final class RedondeoYFormatoTests: XCTestCase {

    func testRedondeaHaciaArribaDesdeCincoMilesimos() {
        XCTAssertEqual(redondear(d("52.048")), d("52.05"))
        XCTAssertEqual(redondear(d("43.9155")), d("43.92"))
        XCTAssertEqual(redondear(d("0.005")), d("0.01"))
    }

    func testRedondeaHaciaAbajo() {
        XCTAssertEqual(redondear(d("57.184")), d("57.18"))
        XCTAssertEqual(redondear(d("0.004")), d("0.00"))
    }

    func testNoCambiaMontosConDosDecimales() {
        XCTAssertEqual(redondear(d("2175.00")), d("2175"))
        XCTAssertEqual(redondear(d("1516.41")), d("1516.41"))
    }

    func testFormatoDeMontos() {
        XCTAssertEqual(formatear(d("2500")), "2,500.00")
        XCTAssertEqual(formatear(d("2631.73")), "2,631.73")
        XCTAssertEqual(formatear(0), "0.00")
        XCTAssertEqual(formatear(d("62.5")), "62.50")
    }
}
