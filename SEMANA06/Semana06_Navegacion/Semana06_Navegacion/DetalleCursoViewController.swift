//
//  DetalleCursoViewController.swift
//  Semana06_Navegacion
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class DetalleCursoViewController: UIViewController {

    @IBOutlet weak var imgIcono: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblEstado: UILabel!
    @IBOutlet weak var btnMatricula: UIButton!

    var curso: Curso?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let curso = curso {
            title = curso.area
            lblNombre.text = curso.nombre
            lblArea.text = curso.area
            lblDescripcion.text = curso.descripcion
            imgIcono.image = UIImage(systemName: curso.icono)
        }
        lblEstado.text = "Estado: sin matrícula"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "abrirMatricula" {
            let matricula = segue.destination as! MatriculaViewController
            matricula.curso = curso
        }
    }

    // Unwind segue: se ejecuta al presionar Confirmar en la matrícula
    @IBAction func regresarConMatricula(_ segue: UIStoryboardSegue) {
        if let matricula = segue.source as? MatriculaViewController {
            lblEstado.text = "Matriculado: \(matricula.nombreAlumno) · \(matricula.modalidad)"
            lblEstado.textColor = .systemGreen
            btnMatricula.isEnabled = false
            btnMatricula.setTitle("Matrícula registrada", for: .normal)
        }
    }

}
