//
//  RegistroViewController.swift
//  Ventas
//
//  A2 · Crear cuenta: nombre, usuario único, clave (mínimo 6) y confirmación, rol.
//

import UIKit

final class RegistroViewController: UIViewController {

    private let nombreCampo = UI.campo("Nombre completo", id: "nombre")
    private let usuarioCampo = UI.campo("Usuario", id: "usuario")
    private let avisoUsuario = UI.etiqueta(estilo: .footnote, color: .systemRed)
    private let claveCampo = UI.campo("Clave (mínimo 6 caracteres)", id: "clave", seguro: true)
    private let confirmarCampo = UI.campo("Confirmar clave", id: "confirmar", seguro: true)
    private let rolSelector = UISegmentedControl(items: [Rol.vendedor, Rol.supervisor])
    private let mensajeError = UI.etiqueta(estilo: .footnote, color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Crear cuenta"   // ① con el botón para volver al login

        avisoUsuario.accessibilityIdentifier = "avisoUsuario"
        avisoUsuario.isHidden = true
        usuarioCampo.addAction(UIAction { [weak self] _ in self?.revisarUsuario() }, for: .editingChanged)

        // Al corregir un campo se oculta el mensaje de error anterior
        for campo in [nombreCampo, usuarioCampo, claveCampo, confirmarCampo] {
            campo.addAction(UIAction { [weak self] _ in self?.mensajeError.isHidden = true }, for: .editingChanged)
        }
        rolSelector.selectedSegmentIndex = 0
        rolSelector.accessibilityIdentifier = "rol"
        mensajeError.accessibilityIdentifier = "mensajeError"
        mensajeError.isHidden = true

        let registrarme = UI.boton("Registrarme", id: "registrarme") { [weak self] in self?.registrar() }
        let contenido = UI.pila([
            UI.etiqueta("Nombre completo", estilo: .subheadline, color: .secondaryLabel), nombreCampo,
            UI.etiqueta("Usuario", estilo: .subheadline, color: .secondaryLabel), usuarioCampo, avisoUsuario,
            UI.etiqueta("Clave", estilo: .subheadline, color: .secondaryLabel), claveCampo, confirmarCampo,
            UI.etiqueta("Rol", estilo: .subheadline, color: .secondaryLabel), rolSelector,
            mensajeError, registrarme,
        ], espacio: 8)
        contenido.setCustomSpacing(20, after: rolSelector)
        UI.formulario(en: self, contenido: contenido)
    }

    /// ③ Aviso en vivo si el usuario ya existe
    private func revisarUsuario() {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let existe = !usuario.isEmpty && Datos.buscarUsuario(usuario) != nil
        avisoUsuario.text = "Ese usuario ya existe"
        avisoUsuario.isHidden = !existe
    }

    private func registrar() {
        view.endEditing(true)
        let nombre = (nombreCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let clave = claveCampo.text ?? ""
        let confirmar = confirmarCampo.text ?? ""

        let error: String?
        if nombre.isEmpty || usuario.isEmpty {
            error = "Completa el nombre y el usuario."
        } else if Datos.buscarUsuario(usuario) != nil {
            error = "El usuario \"\(usuario)\" ya existe. Elige otro."
        } else if clave.count < 6 {
            error = "La clave debe tener al menos 6 caracteres."
        } else if clave != confirmar {
            error = "Las claves no coinciden."
        } else {
            error = nil
        }
        if let error {
            mensajeError.text = error
            mensajeError.isHidden = false
            return
        }

        let rol = rolSelector.selectedSegmentIndex == 1 ? Rol.supervisor : Rol.vendedor
        do {
            let nuevo = try Datos.registrarUsuario(nombre: nombre, usuario: usuario, clave: clave, rol: rol)
            Sesion.shared.iniciar(nuevo)   // ⑥ entra directo a la app
        } catch {
            mensajeError.text = "No se pudo crear la cuenta."
            mensajeError.isHidden = false
        }
    }
}
