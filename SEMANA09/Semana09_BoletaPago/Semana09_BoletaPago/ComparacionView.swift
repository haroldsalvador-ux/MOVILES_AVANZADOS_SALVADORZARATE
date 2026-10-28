//
//  ComparacionView.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import SwiftUI

// Reto: calcula la misma boleta con ONP y con AFP y muestra ambas lado a lado
struct ComparacionView: View {
    let datos: DatosTrabajador

    // Mismos datos, cambiando solo el sistema de pensiones
    var conONP: Boleta {
        var copia = datos
        copia.sistema = .onp
        return Boleta(datos: copia)
    }

    var conAFP: Boleta {
        var copia = datos
        copia.sistema = .afp
        return Boleta(datos: copia)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ONP vs AFP (mismos datos)")
                .font(.headline)

            HStack(alignment: .top, spacing: 8) {
                columna(titulo: "ONP", boleta: conONP)
                columna(titulo: datos.nombreAFP, boleta: conAFP)
            }

            Text(conclusion)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }

    var conclusion: String {
        let diferencia = conAFP.netoAPagar - conONP.netoAPagar
        if diferencia > 0 {
            return "Este mes, con \(datos.nombreAFP) recibe S/ \(formatear(diferencia)) más que con la ONP."
        } else if diferencia < 0 {
            return "Este mes, con la ONP recibe S/ \(formatear(-diferencia)) más que con \(datos.nombreAFP)."
        }
        return "Este mes el neto es el mismo con ONP y con AFP."
    }

    func columna(titulo: String, boleta: Boleta) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).bold()
            Text("Descuentos")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("S/ \(formatear(boleta.totalDescuentos))")
                .monospacedDigit()
            Text("Neto")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("S/ \(formatear(boleta.netoAPagar))")
                .bold()
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
