//
//  DetalleElementoViewController.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class DetalleElementoViewController: UIViewController {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var imgElemento: UIImageView!
    @IBOutlet weak var txtDescripcion: UITextView!

    var elemento: Elemento?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let elemento = elemento {
            lblTitulo.text = elemento.titulo
            imgElemento.image = elemento.foto
            txtDescripcion.text = elemento.descripcion
        }
        imgElemento.layer.cornerRadius = 12
        imgElemento.clipsToBounds = true
    }

}
