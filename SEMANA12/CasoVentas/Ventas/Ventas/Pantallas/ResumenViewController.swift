//
//  ResumenViewController.swift
//  Ventas
//
//  A9 · Resumen del supervisor: saludo, indicadores contra el día anterior,
//  barras de los últimos 7 días, ranking de vendedores del mes y stock bajo.
//  Todo sale de fetch requests (solo ventas no anuladas).
//

import UIKit

final class ResumenViewController: UIViewController {

    private let saludo = UI.etiqueta(estilo: .title2, negrita: true)
    private let rol = UI.insignia(Rol.supervisor, color: .systemPurple)
    private let ventasHoy = TarjetaIndicador(titulo: "Ventas de hoy", id: "resumenHoy")
    private let numeroHoy = TarjetaIndicador(titulo: "N.º de ventas hoy", id: "resumenNumero")
    private let ventasMes = TarjetaIndicador(titulo: "Ventas del mes", id: "resumenMes")
    private let grafico = GraficoBarras()
    private let ranking = UI.pila([], espacio: 6)
    private let stockBajo = UI.pila([], espacio: 6)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // ① saludo con nombre y rol
        saludo.text = "Hola, \(Sesion.shared.usuario?.nombre ?? "")"
        let filaSaludo = UI.pila([saludo, rol], espacio: 8, eje: .horizontal)
        filaSaludo.alignment = .center
        rol.setContentHuggingPriority(.required, for: .horizontal)

        // ② indicadores
        let fila1 = UI.pila([ventasHoy, numeroHoy], espacio: 10, eje: .horizontal)
        fila1.distribution = .fillEqually
        grafico.heightAnchor.constraint(equalToConstant: 170).isActive = true

        func seccion(_ titulo: String) -> UILabel { UI.etiqueta(titulo, estilo: .headline) }
        let contenido = UI.pila([
            filaSaludo, fila1, ventasMes,
            seccion("Últimos 7 días"), grafico,
            seccion("Ranking de vendedores del mes"), ranking,
            seccion("Productos con stock bajo (5 o menos)"), stockBajo,
        ], espacio: 10)
        contenido.setCustomSpacing(18, after: ventasMes)
        contenido.setCustomSpacing(18, after: grafico)
        contenido.setCustomSpacing(18, after: ranking)
        UI.formulario(en: self, contenido: contenido)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let hoy = Fechas.inicioDelDia(Date())
        let manana = Fechas.sumarDias(1, a: hoy)
        let ayer = Fechas.sumarDias(-1, a: hoy)

        let deHoy = Datos.ventasValidas(desde: hoy, hasta: manana)
        let deAyer = Datos.ventasValidas(desde: ayer, hasta: hoy)
        let totalHoy = Datos.sumar(deHoy)
        let totalAyer = Datos.sumar(deAyer)
        ventasHoy.valor.text = Formato.soles(totalHoy)
        let diferencia = Calculo.redondear(totalHoy - totalAyer)
        ventasHoy.detalle.text = "\(diferencia >= 0 ? "▲" : "▼") \(Formato.soles(abs(diferencia))) vs. ayer (\(Formato.soles(totalAyer)))"
        ventasHoy.detalle.textColor = diferencia >= 0 ? .systemGreen : .systemRed
        numeroHoy.valor.text = "\(deHoy.count)"
        numeroHoy.detalle.text = "Ayer: \(deAyer.count)"

        let inicioMes = Fechas.inicioDelMes(Date())
        let delMes = Datos.ventasValidas(desde: inicioMes, hasta: manana)
        ventasMes.valor.text = Formato.soles(Datos.sumar(delMes))
        ventasMes.detalle.text = "\(delMes.count) venta(s) desde el día 1"

        // ③ gráfico de barras de 7 días
        var valores: [Double] = []
        var etiquetas: [String] = []
        for atras in (0...6).reversed() {
            let dia = Fechas.sumarDias(-atras, a: hoy)
            valores.append(Datos.sumar(Datos.ventasValidas(desde: dia, hasta: Fechas.sumarDias(1, a: dia))))
            etiquetas.append(Formato.dia(dia))
        }
        grafico.valores = valores
        grafico.etiquetas = etiquetas
        grafico.accessibilityLabel = "Ventas de los últimos 7 días: " + valores.map { Formato.soles($0) }.joined(separator: ", ")

        // ④ ranking de vendedores del mes
        ranking.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let porVendedor = Dictionary(grouping: delMes) { $0.vendedor?.nombre ?? "Sin vendedor" }
            .map { (nombre: $0.key, total: Datos.sumar($0.value), cantidad: $0.value.count) }
            .sorted { $0.total > $1.total }
        if porVendedor.isEmpty {
            ranking.addArrangedSubview(UI.etiqueta("Aún no hay ventas este mes.", estilo: .subheadline, color: .secondaryLabel))
        }
        for (i, fila) in porVendedor.enumerated() {
            let medalla = ["🥇", "🥈", "🥉"].indices.contains(i) ? ["🥇", "🥈", "🥉"][i] : "\(i + 1)."
            ranking.addArrangedSubview(filaTexto("\(medalla) \(fila.nombre)", "\(Formato.soles(fila.total)) · \(fila.cantidad)"))
        }

        // ⑤ productos con stock bajo
        stockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let bajos = Datos.productosConStockBajo()
        if bajos.isEmpty {
            stockBajo.addArrangedSubview(UI.etiqueta("Ningún producto con stock bajo.", estilo: .subheadline, color: .secondaryLabel))
        }
        for p in bajos {
            let fila = UI.pila([UI.etiqueta(p.nombre ?? ""), UI.insignia("Stock \(p.stock)", color: UI.colorStock(p.stock))], eje: .horizontal)
            fila.alignment = .center
            stockBajo.addArrangedSubview(fila)
        }
    }

    private func filaTexto(_ izquierda: String, _ derecha: String) -> UIView {
        let a = UI.etiqueta(izquierda)
        let b = UI.etiqueta(derecha, estilo: .subheadline, color: .secondaryLabel)
        b.textAlignment = .right
        b.setContentHuggingPriority(.required, for: .horizontal)
        return UI.pila([a, b], espacio: 8, eje: .horizontal)
    }
}
