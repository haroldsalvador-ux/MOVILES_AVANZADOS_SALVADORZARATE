//
//  Elemento.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class Elemento {
    var titulo: String
    var descripcion: String
    var foto: UIImage?

    init(titulo: String, descripcion: String, foto: UIImage?) {
        self.titulo = titulo
        self.descripcion = descripcion
        self.foto = foto
    }
}
