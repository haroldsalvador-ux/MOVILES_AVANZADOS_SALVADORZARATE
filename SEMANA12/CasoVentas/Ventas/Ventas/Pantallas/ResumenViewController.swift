//
//  ResumenViewController.swift
//  Ventas
//
//  A9 · Resumen del supervisor (diseñado en Main.storyboard): saludo, indicadores contra
//  el día anterior, barras de los últimos 7 días, ranking de vendedores del mes y stock bajo.
//  Todo sale de fetch requests (solo ventas no anuladas).
//

import UIKit

final class ResumenViewController: UIViewController {

    @IBOutlet weak var saludo: UILabel!
    @IBOutlet weak var hoyValor: UILabel!
    @IBOutlet weak var hoyDetalle: UILabel!
    @IBOutlet weak var numeroValor: UILabel!
    @IBOutlet weak var numeroDetalle: UILabel!
    @IBOutlet weak var mesValor: UILabel!
    @IBOutlet weak var mesDetalle: UILabel!
    @IBOutlet weak var grafico: GraficoBarras!
    @IBOutlet weak var ranking: UIStackView!
    @IBOutlet weak var stockBajo: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // ① saludo con nombre y rol
        saludo.text = "Hola, \(Sesion.shared.usuario?.nombre ?? "")"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    private func cargar() {
        let hoy = Fechas.inicioDelDia(Date())
        let manana = Fechas.sumarDias(1, a: hoy)
        let ayer = Fechas.sumarDias(-1, a: hoy)

        // ② indicadores contra el día anterior
        let deHoy = Datos.ventasValidas(desde: hoy, hasta: manana)
        let deAyer = Datos.ventasValidas(desde: ayer, hasta: hoy)
        let totalHoy = Datos.sumar(deHoy)
        let totalAyer = Datos.sumar(deAyer)
        hoyValor.text = Formato.soles(totalHoy)
        let diferencia = Calculo.redondear(totalHoy - totalAyer)
        hoyDetalle.text = "\(diferencia >= 0 ? "▲" : "▼") \(Formato.soles(abs(diferencia))) vs. ayer (\(Formato.soles(totalAyer)))"
        hoyDetalle.textColor = diferencia >= 0 ? .systemGreen : .systemRed
        numeroValor.text = "\(deHoy.count)"
        numeroDetalle.text = "Ayer: \(deAyer.count)"

        let inicioMes = Fechas.inicioDelMes(Date())
        let delMes = Datos.ventasValidas(desde: inicioMes, hasta: manana)
        mesValor.text = Formato.soles(Datos.sumar(delMes))
        mesDetalle.text = "\(delMes.count) venta(s) desde el día 1"

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
        let medallas = ["🥇", "🥈", "🥉"]
        for (i, fila) in porVendedor.enumerated() {
            let puesto = i < medallas.count ? medallas[i] : "\(i + 1)."
            let derecha = UI.etiqueta("\(Formato.soles(fila.total)) · \(fila.cantidad)", estilo: .subheadline, color: .secondaryLabel)
            derecha.setContentHuggingPriority(.required, for: .horizontal)
            ranking.addArrangedSubview(UI.pila([UI.etiqueta("\(puesto) \(fila.nombre)"), derecha]))
        }

        // ⑤ productos con stock bajo
        stockBajo.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let bajos = Datos.productosConStockBajo()
        if bajos.isEmpty {
            stockBajo.addArrangedSubview(UI.etiqueta("Ningún producto con stock bajo.", estilo: .subheadline, color: .secondaryLabel))
        }
        for p in bajos {
            stockBajo.addArrangedSubview(UI.pila([UI.etiqueta(p.nombre ?? ""), UI.insignia("Stock \(p.stock)", color: UI.colorStock(p.stock))]))
        }
    }
}
