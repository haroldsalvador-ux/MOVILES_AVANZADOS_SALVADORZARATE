//
//  Componentes.swift
//  Ventas
//
//  Piezas de interfaz que se repiten en varias pantallas.
//  Las pantallas se diseñan en Main.storyboard; aquí quedan los ayudantes de código.
//

import UIKit

enum UI {
    static let azul = UIColor(red: 0.18, green: 0.31, blue: 0.56, alpha: 1)

    /// El formulario del storyboard sube con el teclado y se cierra al tocar fuera de los campos
    static func prepararFormulario(_ controlador: UIViewController) {
        guard let scroll = controlador.view.subviews.compactMap({ $0 as? UIScrollView }).first else { return }
        // Cambia la restricción inferior del scroll (borde de la pantalla) por el borde superior del teclado
        for restriccion in controlador.view.constraints where
            (restriccion.firstItem === scroll || restriccion.secondItem === scroll) &&
            restriccion.firstAttribute == .bottom {
            restriccion.isActive = false
        }
        scroll.bottomAnchor.constraint(equalTo: controlador.view.keyboardLayoutGuide.topAnchor).isActive = true
        let toque = UITapGestureRecognizer(target: controlador.view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        toque.delegate = IgnorarControles.shared
        scroll.addGestureRecognizer(toque)
    }

    static func etiqueta(_ texto: String = "", estilo: UIFont.TextStyle = .body, color: UIColor = .label) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.numberOfLines = 0
        etiqueta.textColor = color
        etiqueta.font = .preferredFont(forTextStyle: estilo)
        return etiqueta
    }

    static func pila(_ vistas: [UIView], espacio: CGFloat = 8, eje: NSLayoutConstraint.Axis = .horizontal) -> UIStackView {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = eje
        pila.spacing = espacio
        pila.alignment = .center
        return pila
    }

    static func alerta(_ controlador: UIViewController, _ titulo: String, _ mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        controlador.present(alerta, animated: true)
    }

    /// Color del stock: verde más de 10, ámbar de 6 a 10, rojo 5 o menos
    static func colorStock(_ stock: Int64) -> UIColor {
        if stock > 10 { return .systemGreen }
        if stock >= 6 { return .systemOrange }
        return .systemRed
    }

    /// Etiqueta con fondo de color, creada por código (filas de stock bajo del resumen)
    static func insignia(_ texto: String, color: UIColor) -> UILabel {
        let etiqueta = PaddingLabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(ofSize: 13, weight: .semibold)
        etiqueta.textColor = .white
        etiqueta.backgroundColor = color
        etiqueta.layer.cornerRadius = 8
        etiqueta.layer.masksToBounds = true
        etiqueta.setContentHuggingPriority(.required, for: .horizontal)
        return etiqueta
    }
}

/// El toque que cierra el teclado no debe actuar sobre campos ni botones
final class IgnorarControles: NSObject, UIGestureRecognizerDelegate {
    static let shared = IgnorarControles()
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var vista = touch.view
        while let actual = vista {
            if actual is UIControl { return false }
            vista = actual.superview
        }
        return true
    }
}

/// UILabel con margen interno (insignias de stock, categoría, rol y ANULADA)
final class PaddingLabel: UILabel {
    var margen = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
    override func drawText(in rect: CGRect) { super.drawText(in: rect.inset(by: margen)) }
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + margen.left + margen.right, height: s.height + margen.top + margen.bottom)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize { intrinsicContentSize }
}

/// Fila horizontal de "chips" para filtrar (categorías, vendedores).
/// En el storyboard es una vista con clase ChipsView; los chips se crean según los datos.
final class ChipsView: UIView {
    var alCambiar: ((Int) -> Void)?
    var opciones: [String] = [] { didSet { reconstruir() } }
    private(set) var seleccion = 0
    private let scroll = UIScrollView()
    private let pila = UIStackView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        scroll.showsHorizontalScrollIndicator = false
        pila.axis = .horizontal
        pila.spacing = 8
        addSubview(scroll)
        scroll.addSubview(pila)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        pila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            pila.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            pila.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            pila.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            pila.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
        ])
    }

    func elegir(_ indice: Int) {
        seleccion = indice
        reconstruir()
        alCambiar?(indice)
    }

    private func reconstruir() {
        if seleccion >= opciones.count { seleccion = 0 }
        pila.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (i, texto) in opciones.enumerated() {
            var config: UIButton.Configuration = i == seleccion ? .filled() : .gray()
            config.title = texto
            config.cornerStyle = .capsule
            config.buttonSize = .small
            if i == seleccion { config.baseBackgroundColor = UI.azul }
            let chip = UIButton(configuration: config, primaryAction: UIAction { [weak self] _ in self?.elegir(i) })
            chip.accessibilityIdentifier = "chip_\(texto)"
            pila.addArrangedSubview(chip)
        }
    }
}

/// Gráfico de barras simple (últimos 7 días). En el storyboard es una vista con clase GraficoBarras.
final class GraficoBarras: UIView {
    var valores: [Double] = [] { didSet { setNeedsDisplay() } }
    var etiquetas: [String] = [] { didSet { setNeedsDisplay() } }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        contentMode = .redraw
        isAccessibilityElement = true
    }

    override func draw(_ rect: CGRect) {
        guard !valores.isEmpty else { return }
        let maximo = max(valores.max() ?? 0, 1)
        let ancho = rect.width / CGFloat(valores.count)
        let texto: CGFloat = 16
        let zona = rect.height - texto * 2 - 6
        let centrado = NSMutableParagraphStyle()
        centrado.alignment = .center
        let atributos: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 10, weight: .medium),
                                                        .foregroundColor: UIColor.secondaryLabel, .paragraphStyle: centrado]
        for (i, valor) in valores.enumerated() {
            let alto = CGFloat(valor / maximo) * zona
            let x = CGFloat(i) * ancho
            let barra = CGRect(x: x + ancho * 0.2, y: texto + 2 + zona - alto, width: ancho * 0.6, height: valor > 0 ? max(alto, 2) : 0)
            (i == valores.count - 1 ? UI.azul : UI.azul.withAlphaComponent(0.55)).setFill()
            UIBezierPath(roundedRect: barra, cornerRadius: 4).fill()
            (valor > 0 ? Formato.corto(valor) : "0").draw(in: CGRect(x: x, y: barra.minY - texto, width: ancho, height: texto), withAttributes: atributos)
            if i < etiquetas.count {
                etiquetas[i].draw(in: CGRect(x: x, y: rect.height - texto, width: ancho, height: texto), withAttributes: atributos)
            }
        }
    }
}
