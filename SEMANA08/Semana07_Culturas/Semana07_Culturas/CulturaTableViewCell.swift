//
//  CulturaTableViewCell.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class CulturaTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgCultura.layer.cornerRadius = 8
        imgCultura.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
