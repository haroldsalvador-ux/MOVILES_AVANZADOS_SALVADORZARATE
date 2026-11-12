//
//  CuentaViewController.swift
//  Ventas
//
//  Cuenta: nombre, usuario, rol y Cerrar sesión.
//

import UIKit

final class CuentaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        guard let usuario = Sesion.shared.usuario else { return }

        let icono = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        icono.tintColor = UI.azul
        icono.contentMode = .scaleAspectFit
        icono.heightAnchor.constraint(equalToConstant: 80).isActive = true

        let nombre = UI.etiqueta(usuario.nombre ?? "", estilo: .title2, negrita: true)
        nombre.textAlignment = .center
        nombre.accessibilityIdentifier = "cuentaNombre"
        let datos = UI.etiqueta("Usuario: \(usuario.usuario ?? "")", estilo: .body, color: .secondaryLabel)
        datos.textAlignment = .center
        let rol = UI.insignia(usuario.rol ?? "", color: usuario.rol == Rol.supervisor ? .systemPurple : .systemTeal)
        rol.accessibilityIdentifier = "cuentaRol"
        let filaRol = UI.pila([UIView(), rol, UIView()], eje: .horizontal)
        filaRol.distribution = .equalCentering

        let cerrar = UI.boton("Cerrar sesión", id: "cerrarSesion") { Sesion.shared.cerrar() }
        cerrar.configuration?.baseBackgroundColor = .systemRed

        let contenido = UI.pila([icono, nombre, datos, filaRol, cerrar], espacio: 14)
        contenido.setCustomSpacing(36, after: filaRol)
        UI.formulario(en: self, contenido: contenido)
    }
}
