//
//  CuentaViewController.swift
//  Ventas
//
//  Pestaña Cuenta: pantalla sencilla hecha por código (no es una de las 9 del caso).
//  Muestra nombre, usuario, rol y el botón Cerrar sesión.
//

import UIKit

final class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cuenta"
        view.backgroundColor = .systemGroupedBackground
        guard let usuario = Sesion.shared.usuario else { return }

        let icono = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        icono.tintColor = UI.azul
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 80).isActive = true
        icono.widthAnchor.constraint(equalToConstant: 80).isActive = true

        let nombre = UI.etiqueta(usuario.nombre ?? "", estilo: .title2)
        nombre.font = .systemFont(ofSize: 22, weight: .bold)
        nombre.textAlignment = .center
        nombre.accessibilityIdentifier = "cuentaNombre"
        let datos = UI.etiqueta("Usuario: \(usuario.usuario ?? "")", color: .secondaryLabel)
        datos.textAlignment = .center
        let rol = UI.insignia(usuario.rol ?? "", color: usuario.rol == Rol.supervisor ? .systemPurple : .systemTeal)
        rol.accessibilityIdentifier = "cuentaRol"

        var config = UIButton.Configuration.filled()
        config.title = "Cerrar sesión"
        config.baseBackgroundColor = .systemRed
        config.cornerStyle = .large
        config.buttonSize = .large
        let cerrar = UIButton(configuration: config, primaryAction: UIAction { _ in Sesion.shared.cerrar() })
        cerrar.accessibilityIdentifier = "cerrarSesion"

        let pila = UIStackView(arrangedSubviews: [icono, nombre, datos, rol, cerrar])
        pila.axis = .vertical
        pila.spacing = 14
        pila.alignment = .center
        pila.setCustomSpacing(36, after: rol)
        view.addSubview(pila)
        pila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pila.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            pila.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pila.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cerrar.widthAnchor.constraint(equalTo: pila.widthAnchor),
            nombre.widthAnchor.constraint(equalTo: pila.widthAnchor),
        ])
    }
}
