//
//  ElementoTableViewCell.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class ElementoTableViewCell: UITableViewCell {

    @IBOutlet weak var imgElemento: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgElemento.layer.cornerRadius = 10
        imgElemento.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
