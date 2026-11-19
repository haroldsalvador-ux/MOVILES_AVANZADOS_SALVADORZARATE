//
//  VentaCelda.swift
//  Ventas
//
//  Celda de una venta, diseñada en el storyboard (prototipo "Venta" de Mis ventas
//  y de Ventas del equipo). Las anuladas se ven tachadas.
//

import UIKit

final class VentaCelda: UITableViewCell {
    @IBOutlet weak var cliente: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var vendedor: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var anulada: UILabel!

    func mostrar(_ venta: Venta, conVendedor: Bool) {
        selectionStyle = .none
        let nombre = venta.cliente?.nombre ?? ""
        let montoTexto = Formato.soles(venta.total)
        if venta.anulada {
            // ⑤ venta anulada: tachada y con etiqueta
            let tachado: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.secondaryLabel]
            cliente.attributedText = NSAttributedString(string: nombre, attributes: tachado)
            total.attributedText = NSAttributedString(string: montoTexto, attributes: tachado)
        } else {
            cliente.attributedText = nil
            total.attributedText = nil
            cliente.text = nombre
            cliente.textColor = .label
            total.text = montoTexto
            total.textColor = .label
        }
        anulada.isHidden = !venta.anulada
        var texto = "\(venta.producto?.nombre ?? "") × \(venta.cantidad) · \(Formato.fecha(venta.fecha))"
        if venta.anulada, let motivo = venta.motivoAnulacion { texto += "\nMotivo: \(motivo)" }
        detalle.text = texto
        // relación venta ▸ vendedor
        vendedor.text = "Vendedor: \(venta.vendedor?.nombre ?? "")"
        vendedor.isHidden = !conVendedor
        accessibilityIdentifier = "venta_\(nombre)_\(montoTexto)"
    }
}
