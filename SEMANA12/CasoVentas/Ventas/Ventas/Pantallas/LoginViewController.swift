//
//  LoginViewController.swift
//  Ventas
//
//  A1 · Login (diseñado en Main.storyboard): usuario, clave oculta,
//  mensaje genérico, Ingresar y Crear cuenta (segue que presenta A2).
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usuarioCampo: UITextField!
    @IBOutlet weak var claveCampo: UITextField!
    @IBOutlet weak var mensajeError: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        UI.prepararFormulario(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        claveCampo.text = ""
        mensajeError.isHidden = true
    }

    /// Al escribir se oculta el mensaje de error anterior
    @IBAction func campoCambio(_ sender: UITextField) {
        mensajeError.isHidden = true
    }

    @IBAction func ingresar(_ sender: UIButton) {
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
