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

    // MARK: - Retenciones / descuentos

    // 13% del total de remuneraciones, solo si está en la ONP
    var onp: Decimal {
        datos.sistema == .onp ? redondear(totalRemuneraciones * Parametros.tasaONP) : 0
    }

    // Tasas de la AFP elegida (nil si está en la ONP)
    var tasasAFP: TasasAFP? {
        datos.sistema == .afp ? Parametros.tasasAFP[datos.nombreAFP] : nil
    }

    // Los tres descuentos de la AFP se calculan sobre el total de remuneraciones
    var afpFondo: Decimal {
        guard let tasas = tasasAFP else { return 0 }
        return redondear(totalRemuneraciones * tasas.fondo)
    }

    var afpComision: Decimal {
        guard let tasas = tasasAFP else { return 0 }
        return redondear(totalRemuneraciones * tasas.comision)
    }

    var afpSeguro: Decimal {
        guard let tasas = tasasAFP else { return 0 }
        return redondear(totalRemuneraciones * tasas.seguro)
    }

    // Monto ingresado, se resta tal cual
    var adelantos: Decimal {
        redondear(datos.adelantos)
    }

    // Array con los conceptos del bloque Retenciones / Descuentos
    var descuentos: [Concepto] {
        [
            Concepto(nombre: "ONP", monto: onp),
            Concepto(nombre: "AFP fondo", monto: afpFondo),
            Concepto(nombre: "AFP comisión", monto: afpComision),
            Concepto(nombre: "AFP seguro", monto: afpSeguro),
            Concepto(nombre: "Adelantos", monto: adelantos)
        ]
    }

    // Pensión (ONP o AFP) + adelantos
    var totalDescuentos: Decimal {
        descuentos.reduce(0) { $0 + $1.monto }
    }

    // MARK: - Neto y aportes del empleador

    var netoAPagar: Decimal {
        totalRemuneraciones - totalDescuentos
    }

    // 9% del total de remuneraciones. Lo paga el empleador: no se descuenta al trabajador
    var esSalud: Decimal {
        redondear(totalRemuneraciones * Parametros.tasaEsSalud)
    }

    var aportaciones: [Concepto] {
        [Concepto(nombre: "EsSalud (9%)", monto: esSalud)]
    }
}
