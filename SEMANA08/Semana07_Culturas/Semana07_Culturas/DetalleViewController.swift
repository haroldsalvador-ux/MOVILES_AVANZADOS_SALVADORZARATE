//
//  DetalleViewController.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let cultura = cultura {
            title = cultura.nombre
            lblNombre.text = cultura.nombre
            lblRegion.text = "Región: " + cultura.region
            lblDescripcion.text = cultura.descripcion
            imgCultura.image = cultura.foto
        }
        imgCultura.layer.cornerRadius = 12
        imgCultura.clipsToBounds = true
    }

}
