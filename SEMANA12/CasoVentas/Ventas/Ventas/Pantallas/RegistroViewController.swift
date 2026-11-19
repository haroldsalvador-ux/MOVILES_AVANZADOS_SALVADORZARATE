//
//  RegistroViewController.swift
//  Ventas
//
//  A2 · Crear cuenta (diseñado en Main.storyboard): nombre, usuario único,
//  clave (mínimo 6) y su confirmación, rol y Registrarme.
//

import UIKit

final class RegistroViewController: UIViewController {

    @IBOutlet weak var nombreCampo: UITextField!
    @IBOutlet weak var usuarioCampo: UITextField!
    @IBOutlet weak var avisoUsuario: UILabel!
    @IBOutlet weak var claveCampo: UITextField!
    @IBOutlet weak var confirmarCampo: UITextField!
    @IBOutlet weak var rolSelector: UISegmentedControl!
    @IBOutlet weak var mensajeError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        UI.prepararFormulario(self)
    }

    /// ① Volver al login (cierra la pantalla presentada)
    @IBAction func volver(_ sender: UIButton) {
        dismiss(animated: true)
    }

    /// Al corregir un campo se oculta el mensaje de error anterior
    @IBAction func campoCambio(_ sender: UITextField) {
        mensajeError.isHidden = true
    }

    @IBAction func rolCambio(_ sender: UISegmentedControl) {
        view.endEditing(true)
    }

    /// ③ Aviso en vivo si el usuario ya existe
    @IBAction func usuarioCambio(_ sender: UITextField) {
        let usuario = (usuarioCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        avisoUsuario.isHidden = usuario.isEmpty || Datos.buscarUsuario(usuario) == nil
    }

    @IBAction func registrar(_ sender: UIButton) {
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
