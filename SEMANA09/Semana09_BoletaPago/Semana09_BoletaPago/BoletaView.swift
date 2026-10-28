//
//  BoletaView.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import SwiftUI

// Muestra un monto como en la boleta: 2,500.00
func formatear(_ monto: Decimal) -> String {
    let formato = NumberFormatter()
    formato.locale = Locale(identifier: "en_US")
    formato.numberStyle = .decimal
    formato.minimumFractionDigits = 2
    formato.maximumFractionDigits = 2
    return formato.string(from: monto as NSDecimalNumber) ?? "0.00"
}

// La boleta imita las tres columnas del formato real; en el celular van una debajo de otra
struct BoletaView: View {
    let boleta: Boleta
    let encabezado: Encabezado

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Encabezado: quién paga, a quién y con qué datos
            VStack(alignment: .leading, spacing: 4) {
                Text("BOLETA DE EJEMPLO")
                    .font(.headline)
                Text("Razón social: \(encabezado.razonSocial)")
                Text("Trabajador: \(encabezado.trabajador)")
                Text("Días laborados: \(boleta.datos.diasLaborados) · Sistema: \(nombreSistema)")
            }
            .font(.subheadline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            BloqueView(titulo: "REMUNERACIONES", conceptos: boleta.remuneraciones,
                       nombreTotal: "Total remuneraciones", total: boleta.totalRemuneraciones)
            BloqueView(titulo: "RETENCIONES / DESCUENTOS", conceptos: boleta.descuentos,
                       nombreTotal: "Total descuentos", total: boleta.totalDescuentos)
            BloqueView(titulo: "APORTACIONES DEL EMPLEADOR", conceptos: boleta.aportaciones,
                       nombreTotal: nil, total: nil)

            HStack {
                Text("NETO A PAGAR:")
                    .font(.headline)
                Spacer()
                Text("S/ \(formatear(boleta.netoAPagar))")
                    .font(.title2)
                    .bold()
            }
            .padding()
            .background(Color.green.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

extension BoletaView {
    var nombreSistema: String {
        boleta.datos.sistema == .onp ? "ONP" : boleta.datos.nombreAFP
    }
}

// Un bloque de la boleta: título, una fila por concepto y el total
struct BloqueView: View {
    let titulo: String
    let conceptos: [Concepto]
    let nombreTotal: String?
    let total: Decimal?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(titulo)
                .font(.caption)
                .bold()
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue)

            ForEach(conceptos) { concepto in
                HStack {
                    Text(concepto.nombre)
                    Spacer()
                    Text(formatear(concepto.monto))
                        .monospacedDigit()
                }
                .font(.subheadline)
                .padding(.horizontal, 8)
            }

            if let nombreTotal, let total {
                HStack {
                    Text(nombreTotal).bold()
                    Spacer()
                    Text(formatear(total)).bold().monospacedDigit()
                }
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.top, 4)
            }
        }
        .padding(.bottom, 8)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
