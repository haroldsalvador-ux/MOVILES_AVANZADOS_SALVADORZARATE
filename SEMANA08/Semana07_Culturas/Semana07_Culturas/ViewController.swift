//
//  ViewController.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaCulturas: UITableView!

    var culturas: [Cultura] = DatosCulturas.obtenerCulturas()

    var culturaSeleccionada: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaCulturas.delegate = self
        tablaCulturas.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CulturaTableViewCell
        let cultura = culturas[indexPath.row]
        celda.lblNombre.text = cultura.nombre
        celda.imgCultura.image = cultura.foto
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        culturaSeleccionada = culturas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "mostrarDetalle", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalle" {
            let detalle = segue.destination as! DetalleViewController
            detalle.cultura = culturaSeleccionada
        }
    }

}
