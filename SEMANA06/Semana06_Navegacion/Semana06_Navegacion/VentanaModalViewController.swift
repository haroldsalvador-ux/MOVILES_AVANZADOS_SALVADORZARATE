//
//  VentanaModalViewController.swift
//  Semana06_Navegacion
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class VentanaModalViewController: UIViewController {

    @IBOutlet weak var lblEstilo: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!

    var nombreEstilo = ""
    var descripcion = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        lblEstilo.text = nombreEstilo
        lblDescripcion.text = descripcion
    }

    @IBAction func cerrar(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
