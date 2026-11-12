//
//  Componentes.swift
//  Ventas
//
//  Piezas de interfaz que se repiten en varias pantallas.
//

import UIKit

enum UI {
    static let azul = UIColor(red: 0.18, green: 0.31, blue: 0.56, alpha: 1)

    static func campo(_ placeholder: String, id: String, seguro: Bool = false, teclado: UIKeyboardType = .default) -> UITextField {
        let campo = UITextField()
        campo.placeholder = placeholder
        campo.borderStyle = .roundedRect
        campo.autocapitalizationType = seguro || id == "usuario" ? .none : .words
        campo.autocorrectionType = .no
        campo.isSecureTextEntry = seguro
        if seguro { campo.textContentType = .oneTimeCode }   // evita el autollenado de claves del simulador
        campo.keyboardType = teclado
        campo.accessibilityIdentifier = id
        campo.font = .preferredFont(forTextStyle: .body)
        campo.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return campo
    }

    static func boton(_ titulo: String, id: String, relleno: Bool = true, accion: @escaping () -> Void) -> UIButton {
        var config: UIButton.Configuration = relleno ? .filled() : .plain()
        config.title = titulo
        config.cornerStyle = .large
        config.buttonSize = .large
        if relleno { config.baseBackgroundColor = azul }
        let boton = UIButton(configuration: config, primaryAction: UIAction { _ in accion() })
        boton.accessibilityIdentifier = id
        return boton
    }

    static func etiqueta(_ texto: String = "", estilo: UIFont.TextStyle = .body, color: UIColor = .label, negrita: Bool = false) -> UILabel {
        let etiqueta = UILabel()
        etiqueta.text = texto
        etiqueta.numberOfLines = 0
        etiqueta.textColor = color
        let fuente = UIFont.preferredFont(forTextStyle: estilo)
        etiqueta.font = negrita ? UIFont.systemFont(ofSize: fuente.pointSize, weight: .bold) : fuente
        etiqueta.adjustsFontForContentSizeCategory = true
        return etiqueta
    }

    static func pila(_ vistas: [UIView], espacio: CGFloat = 12, eje: NSLayoutConstraint.Axis = .vertical) -> UIStackView {
        let pila = UIStackView(arrangedSubviews: vistas)
        pila.axis = eje
        pila.spacing = espacio
        return pila
    }

    /// Coloca el contenido en un scroll que sube con el teclado
    static func formulario(en controlador: UIViewController, contenido: UIStackView) {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .interactive
        scroll.alwaysBounceVertical = true
        // Tocar fuera de los campos cierra el teclado
        let toque = UITapGestureRecognizer(target: controlador.view, action: #selector(UIView.endEditing(_:)))
        toque.cancelsTouchesInView = false
        toque.delegate = IgnorarControles.shared
        scroll.addGestureRecognizer(toque)
        controlador.view.addSubview(scroll)
        scroll.addSubview(contenido)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        contenido.translatesAutoresizingMaskIntoConstraints = false
        let guia = controlador.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: guia.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: controlador.view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: controlador.view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: controlador.view.keyboardLayoutGuide.topAnchor),
            contenido.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            contenido.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -20),
            contenido.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: 20),
            contenido.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -20),
        ])
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

    /// Etiqueta con fondo de color (stock, anulada, rol)
    static func insignia(_ texto: String, color: UIColor) -> UILabel {
        let etiqueta = PaddingLabel()
        etiqueta.text = texto
        etiqueta.font = .systemFont(ofSize: 13, weight: .semibold)
        etiqueta.textColor = .white
        etiqueta.backgroundColor = color
        etiqueta.layer.cornerRadius = 8
        etiqueta.layer.masksToBounds = true
        etiqueta.sizeToFit()
        return etiqueta
    }

    /// Contenedor con altura fija para usar como cabecera de una tabla
    static func cabecera(_ contenido: UIView, alto: CGFloat) -> UIView {
        let contenedor = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: alto))
        contenedor.addSubview(contenido)
        contenido.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contenido.topAnchor.constraint(equalTo: contenedor.topAnchor, constant: 8),
            contenido.leadingAnchor.constraint(equalTo: contenedor.leadingAnchor, constant: 16),
            contenido.trailingAnchor.constraint(equalTo: contenedor.trailingAnchor, constant: -16),
            contenido.bottomAnchor.constraint(lessThanOrEqualTo: contenedor.bottomAnchor, constant: -8),
        ])
        return contenedor
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

final class PaddingLabel: UILabel {
    var margen = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
    override func drawText(in rect: CGRect) { super.drawText(in: rect.inset(by: margen)) }
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + margen.left + margen.right, height: s.height + margen.top + margen.bottom)
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize { intrinsicContentSize }
}

/// Fila horizontal de "chips" para filtrar (categorías, vendedores)
final class ChipsView: UIScrollView {
    var alCambiar: ((Int) -> Void)?
    var opciones: [String] = [] { didSet { reconstruir() } }
    private(set) var seleccion = 0
    private let pila = UIStackView()

    init() {
        super.init(frame: .zero)
        showsHorizontalScrollIndicator = false
        pila.axis = .horizontal
        pila.spacing = 8
        addSubview(pila)
        pila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pila.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            pila.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            pila.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            pila.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            pila.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor),
            heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

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

/// Tarjeta con un indicador (título, valor y detalle)
final class TarjetaIndicador: UIView {
    let titulo = UI.etiqueta(estilo: .caption1, color: .secondaryLabel)
    let valor = UI.etiqueta(estilo: .title3, negrita: true)
    let detalle = UI.etiqueta(estilo: .caption1, color: .secondaryLabel)

    init(titulo texto: String, id: String) {
        super.init(frame: .zero)
        titulo.text = texto
        valor.accessibilityIdentifier = id
        valor.adjustsFontSizeToFitWidth = true
        valor.minimumScaleFactor = 0.6
        valor.numberOfLines = 1
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        let pila = UI.pila([titulo, valor, detalle], espacio: 2)
        addSubview(pila)
        pila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            pila.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            pila.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            pila.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }
}

/// Gráfico de barras simple (últimos 7 días)
final class GraficoBarras: UIView {
    var valores: [Double] = [] { didSet { setNeedsDisplay() } }
    var etiquetas: [String] = [] { didSet { setNeedsDisplay() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentMode = .redraw
        isAccessibilityElement = true
        accessibilityIdentifier = "grafico7dias"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func draw(_ rect: CGRect) {
        guard !valores.isEmpty else { return }
        let maximo = max(valores.max() ?? 0, 1)
        let ancho = rect.width / CGFloat(valores.count)
        let texto: CGFloat = 16
        let zona = rect.height - texto * 2 - 6
        let fuente = UIFont.systemFont(ofSize: 10, weight: .medium)
        let centrado = NSMutableParagraphStyle()
        centrado.alignment = .center
        let atributos: [NSAttributedString.Key: Any] = [.font: fuente, .foregroundColor: UIColor.secondaryLabel, .paragraphStyle: centrado]

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
