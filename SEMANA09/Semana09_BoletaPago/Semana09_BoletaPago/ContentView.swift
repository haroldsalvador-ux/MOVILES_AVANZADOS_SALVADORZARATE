//
//  ContentView.swift
//  Semana09_BoletaPago
//
//  Created by Harold Salvador Zarate on 28/10/26.
//

import SwiftUI

struct ContentView: View {
    // Encabezado (reto): nombres ficticios
    @State private var razonSocial = "Empresa Ejemplo S.A.C."
    @State private var trabajador = "Trabajador de ejemplo"

    // Datos del formulario: los TextField guardan texto, luego se convierte a número
    @State private var sueldoTexto = ""
    @State private var diasTexto = "30"
    @State private var tieneHijos = false
    @State private var sistema: SistemaPensiones = .onp
    @State private var nombreAFP = "AFP Ejemplo"
    @State private var horas25Texto = "0"
    @State private var horas35Texto = "0"
    @State private var adelantosTexto = "0"

    // Resultado: la boleta calculada o el mensaje de error
    @State private var boleta: Boleta?
    @State private var mensajeError = ""
    // Caso de prueba cargado (para comparar con la respuesta del enunciado)
    @State private var casoCargado: CasoPrueba?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Boleta de pago")
                    .font(.largeTitle)
                    .bold()
                Text("Boleta de ejemplo · datos ficticios")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                casos

                formulario

                Button {
                    calcular()
                } label: {
                    Text("Calcular")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Si los datos no son válidos se muestra el mensaje y no se calcula
                if !mensajeError.isEmpty {
                    Text(mensajeError)
                        .foregroundStyle(.red)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Al pulsar Calcular, la boleta aparece debajo del formulario
                if let boleta {
                    BoletaView(boleta: boleta,
                               encabezado: Encabezado(razonSocial: razonSocial, trabajador: trabajador))
                    verificacion(de: boleta)
                    ComparacionView(datos: boleta.datos)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    // MARK: - Calcular

    func calcular() {
        casoCargado = nil
        let resultado = validar(sueldo: sueldoTexto, dias: diasTexto, tieneHijos: tieneHijos,
                                sistema: sistema, nombreAFP: nombreAFP, horas25: horas25Texto,
                                horas35: horas35Texto, adelantos: adelantosTexto)
        switch resultado {
        case .valido(let datos):
            mensajeError = ""
            boleta = Boleta(datos: datos)
        case .invalido(let mensaje):
            mensajeError = mensaje
            boleta = nil
        }
    }

    // MARK: - Casos de prueba

    var casos: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Cargar caso de prueba").font(.subheadline).bold()
            HStack {
                ForEach(casosPrueba) { caso in
                    Button(caso.nombre) {
                        cargar(caso)
                    }
                    .buttonStyle(.bordered)
                    .font(.caption)
                }
            }
        }
    }

    // Copia los datos del caso al formulario y calcula
    func cargar(_ caso: CasoPrueba) {
        let datos = caso.datos
        sueldoTexto = "\(datos.sueldoBasico)"
        diasTexto = "\(datos.diasLaborados)"
        tieneHijos = datos.tieneHijos
        sistema = datos.sistema
        nombreAFP = datos.nombreAFP
        horas25Texto = "\(datos.horas25)"
        horas35Texto = "\(datos.horas35)"
        adelantosTexto = "\(datos.adelantos)"
        calcular()
        casoCargado = caso
    }

    // Compara el neto calculado con la respuesta del enunciado
    @ViewBuilder
    func verificacion(de boleta: Boleta) -> some View {
        if let caso = casoCargado {
            if let esperado = caso.netoEsperado {
                let coincide = boleta.netoAPagar == esperado
                Text(coincide
                     ? "✓ \(caso.nombre): coincide con la respuesta del enunciado (S/ \(formatear(esperado)))"
                     : "✗ \(caso.nombre): se esperaba S/ \(formatear(esperado))")
                    .font(.footnote)
                    .foregroundStyle(coincide ? .green : .red)
            } else {
                Text("\(caso.nombre): el enunciado no trae respuesta, lo revisa el docente.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Formulario

    var formulario: some View {
        VStack(alignment: .leading, spacing: 12) {
            campoTexto("Razón social (ficticia)", texto: $razonSocial)
            campoTexto("Nombre del trabajador (ficticio)", texto: $trabajador)
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

    // TextField de texto libre para el encabezado
    func campoTexto(_ titulo: String, texto: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo).font(.subheadline).bold()
            TextField(titulo, text: texto)
                .textFieldStyle(.roundedBorder)
        }
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
