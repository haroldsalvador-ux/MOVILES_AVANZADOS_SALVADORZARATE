//
//  VentaCelda.swift
//  Ventas
//
//  Fila de una venta (Mis ventas y Ventas del equipo). Las anuladas se ven tachadas.
//

import UIKit

final class VentaCelda: UITableViewCell {
    private let cliente = UI.etiqueta(estilo: .headline)
    private let detalle = UI.etiqueta(estilo: .footnote, color: .secondaryLabel)
    private let vendedor = UI.etiqueta(estilo: .footnote, color: UI.azul)
    private let total = UI.etiqueta(estilo: .headline)
    private let anulada = UI.insignia("ANULADA", color: .systemRed)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        total.textAlignment = .right
        let derecha = UI.pila([total, anulada], espacio: 4)
        derecha.alignment = .trailing
        let izquierda = UI.pila([cliente, detalle, vendedor], espacio: 2)
        let fila = UI.pila([izquierda, derecha], espacio: 8, eje: .horizontal)
        fila.alignment = .center
        contentView.addSubview(fila)
        fila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        derecha.setContentCompressionResistancePriority(.required, for: .horizontal)
        total.setContentHuggingPriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    func mostrar(_ venta: Venta, conVendedor: Bool) {
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
