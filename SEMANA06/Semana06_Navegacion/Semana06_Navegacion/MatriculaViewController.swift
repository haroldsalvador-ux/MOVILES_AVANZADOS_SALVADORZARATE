//
//  MatriculaViewController.swift
//  Semana06_Navegacion
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class MatriculaViewController: UIViewController {

    @IBOutlet weak var lblCurso: UILabel!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var segModalidad: UISegmentedControl!

    var curso: Curso?
    var nombreAlumno = ""
    var modalidad = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblCurso.text = curso?.nombre
    }

    @IBAction func cancelar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "confirmarMatricula" && (txtNombre.text ?? "").isEmpty {
            let alerta = UIAlertController(title: "Falta tu nombre", message: "Ingresa tu nombre para confirmar la matrícula.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
            present(alerta, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmarMatricula" {
            nombreAlumno = txtNombre.text ?? ""
            modalidad = segModalidad.titleForSegment(at: segModalidad.selectedSegmentIndex) ?? ""
        }
    }

}
