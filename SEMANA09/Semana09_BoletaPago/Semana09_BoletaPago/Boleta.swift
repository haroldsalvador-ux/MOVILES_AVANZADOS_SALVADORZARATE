//
//  Boleta.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import Foundation

// Redondea a 2 decimales (0.005 sube), igual que REDONDEAR(x; 2) en Excel
func redondear(_ valor: Decimal) -> Decimal {
    var entrada = valor
    var resultado = Decimal()
    NSDecimalRound(&resultado, &entrada, 2, .plain)
    return resultado
}

// La clase Boleta hace todo el cálculo. La pantalla solo le pasa los datos y muestra el resultado.
class Boleta {
    let datos: DatosTrabajador

    init(datos: DatosTrabajador) {
        self.datos = datos
    }

    // MARK: - Remuneraciones

    // Sueldo básico ÷ 30 × días laborados
    var sueldoComputable: Decimal {
        redondear(datos.sueldoBasico / Parametros.diasDelMes * Decimal(datos.diasLaborados))
    }

    // 10% de la RMV si tiene hijos (no se prorratea por días)
    var asignacionFamiliar: Decimal {
        datos.tieneHijos ? redondear(Parametros.rmv * Parametros.tasaAsignacionFamiliar) : 0
    }

    // Sueldo básico ÷ 30 ÷ 8 (no se redondea: solo sirve para calcular las horas extras)
    var valorHora: Decimal {
        datos.sueldoBasico / Parametros.diasDelMes / Parametros.horasPorDia
    }

    // Valor hora × 1.25 × horas
    var horasExtras25: Decimal {
        redondear(valorHora * Parametros.recargoHoras25 * datos.horas25)
    }

    // Valor hora × 1.35 × horas
    var horasExtras35: Decimal {
        redondear(valorHora * Parametros.recargoHoras35 * datos.horas35)
    }

    // Array con los conceptos del bloque Remuneraciones
    var remuneraciones: [Concepto] {
        [
            Concepto(nombre: "Sueldo computable", monto: sueldoComputable),
            Concepto(nombre: "Asignación familiar", monto: asignacionFamiliar),
            Concepto(nombre: "Horas extras 25%", monto: horasExtras25),
            Concepto(nombre: "Horas extras 35%", monto: horasExtras35)
        ]
    }

    // Cada concepto ya está redondeado, así que solo se suman
    var totalRemuneraciones: Decimal {
        remuneraciones.reduce(0) { $0 + $1.monto }
    }
}
