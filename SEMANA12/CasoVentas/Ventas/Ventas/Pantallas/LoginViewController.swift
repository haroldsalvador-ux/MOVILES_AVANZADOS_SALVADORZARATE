//
//  LoginViewController.swift
//  Ventas
//
//  A1 · Login (diseñado en Main.storyboard): usuario, clave oculta,
//  mensaje genérico, Ingresar (segue entrar a las pestañas) y Crear cuenta (segue a A2).
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
        Sesion.shared.usuario = encontrado
        performSegue(withIdentifier: "entrar", sender: nil)   // A1 → Pestañas
    }

    /// Antes de entrar se arman las pestañas según el rol del usuario
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entrar", let pestanas = segue.destination as? UITabBarController,
           let usuario = Sesion.shared.usuario {
            PestanasPorRol.configurar(pestanas, para: usuario)
        }
    }
}
