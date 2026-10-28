//
//  ContentView.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import SwiftUI

struct ContentView: View {
    // Datos del formulario: los TextField guardan texto, luego se convierte a número
    @State private var sueldoTexto = ""
    @State private var diasTexto = "30"
    @State private var tieneHijos = false
    @State private var sistema: SistemaPensiones = .onp
    @State private var nombreAFP = "AFP Ejemplo"
    @State private var horas25Texto = "0"
    @State private var horas35Texto = "0"
    @State private var adelantosTexto = "0"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Boleta de pago")
                    .font(.largeTitle)
                    .bold()
                Text("Boleta de ejemplo · datos ficticios")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                formulario

                Button {
                    // El cálculo se conecta en el siguiente hito
                } label: {
                    Text("Calcular")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Formulario

    var formulario: some View {
        VStack(alignment: .leading, spacing: 12) {
            campo("Sueldo básico (S/)", texto: $sueldoTexto, ejemplo: "2500.00")
            campo("Días laborados (1 a 30)", texto: $diasTexto, ejemplo: "30", teclado: .numberPad)

            Text("¿Tiene hijos?").font(.subheadline).bold()
            Picker("¿Tiene hijos?", selection: $tieneHijos) {
                Text("No").tag(false)
                Text("Sí").tag(true)
            }
            .pickerStyle(.segmented)

            Text("Sistema de pensiones").font(.subheadline).bold()
            Picker("Sistema de pensiones", selection: $sistema) {
                ForEach(SistemaPensiones.allCases, id: \.self) { opcion in
                    Text(opcion.rawValue).tag(opcion)
                }
            }
            .pickerStyle(.segmented)

            // Solo aparece si eligió AFP
            if sistema == .afp {
                HStack {
                    Text("AFP").font(.subheadline).bold()
                    Spacer()
                    Picker("AFP", selection: $nombreAFP) {
                        ForEach(Parametros.nombresAFP, id: \.self) { nombre in
                            Text(nombre).tag(nombre)
                        }
                    }
                }
            }

            HStack(spacing: 12) {
                campo("Horas extras 25%", texto: $horas25Texto, ejemplo: "0")
                campo("Horas extras 35%", texto: $horas35Texto, ejemplo: "0")
            }
            campo("Adelantos (S/)", texto: $adelantosTexto, ejemplo: "0.00")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // Un TextField con su etiqueta encima
    func campo(_ titulo: String, texto: Binding<String>, ejemplo: String, teclado: UIKeyboardType = .decimalPad) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).font(.subheadline).bold()
            TextField(ejemplo, text: texto)
                .keyboardType(teclado)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    ContentView()
}
