//
//  Cultura.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class Cultura {
    var nombre: String
    var region: String
    var descripcion: String
    var foto: UIImage?

    init(nombre: String, region: String, descripcion: String, foto: UIImage?) {
        self.nombre = nombre
        self.region = region
        self.descripcion = descripcion
        self.foto = foto
    }
}
