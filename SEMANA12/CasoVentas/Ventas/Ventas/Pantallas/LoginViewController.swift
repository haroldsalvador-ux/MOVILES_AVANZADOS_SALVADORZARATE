//
//  LoginViewController.swift
//  Ventas
//
//  A1 · Login: usuario, clave oculta, mensaje genérico, Ingresar y Crear cuenta.
//

import UIKit

class LoginViewController: UIViewController {

    private let usuarioCampo = UI.campo("Usuario", id: "usuario")
    private let claveCampo = UI.campo("Clave", id: "clave", seguro: true)
    private let mensajeError = UI.etiqueta(estilo: .footnote, color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = ""
        navigationItem.backButtonTitle = "Login"

        // ① Logo y nombre
        let logo = UIImageView(image: UIImage(systemName: "cart.fill"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        let circulo = UIView()
        circulo.backgroundColor = UI.azul
        circulo.layer.cornerRadius = 44
        circulo.addSubview(logo)
        circulo.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circulo.widthAnchor.constraint(equalToConstant: 88),
            circulo.heightAnchor.constraint(equalToConstant: 88),
            logo.centerXAnchor.constraint(equalTo: circulo.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: circulo.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 44),
            logo.heightAnchor.constraint(equalToConstant: 44),
        ])
        let nombre = UI.etiqueta("Ventas", estilo: .largeTitle, negrita: true)
        let lema = UI.etiqueta("Inicia sesión para continuar", estilo: .subheadline, color: .secondaryLabel)
        let encabezado = UI.pila([circulo, nombre, lema], espacio: 8)
        encabezado.alignment = .center

        // ④ Mensaje de error genérico (oculto al inicio)
        mensajeError.accessibilityIdentifier = "mensajeError"
        mensajeError.textAlignment = .center
        mensajeError.isHidden = true
        for campo in [usuarioCampo, claveCampo] {
            campo.addAction(UIAction { [weak self] _ in self?.mensajeError.isHidden = true }, for: .editingChanged)
        }

        let ingresar = UI.boton("Ingresar", id: "ingresar") { [weak self] in self?.ingresar() }
        let crearCuenta = UI.boton("¿No tienes cuenta? Crear cuenta", id: "crearCuenta", relleno: false) { [weak self] in
            self?.navigationController?.pushViewController(RegistroViewController(), animated: true)
        }

        let contenido = UI.pila([encabezado, usuarioCampo, claveCampo, mensajeError, ingresar, crearCuenta], espacio: 14)
        contenido.setCustomSpacing(28, after: encabezado)
        UI.formulario(en: self, contenido: contenido)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        claveCampo.text = ""
        mensajeError.isHidden = true
    }

    private func ingresar() {
        view.endEditing(true)
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveCampo.text ?? ""
        guard let encontrado = Datos.login(usuario: usuario, clave: clave) else {
            // No dice si falló el usuario o la clave
            mensajeError.text = "Usuario o clave incorrectos"
            mensajeError.isHidden = false
            return
        }
        Sesion.shared.iniciar(encontrado)
    }
}
