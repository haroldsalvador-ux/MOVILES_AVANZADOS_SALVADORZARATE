//
//  DetalleViewController.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class DetalleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imgCultura: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblRegion: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var tablaElementos: UITableView!

    var cultura: Cultura?
    var elementoSeleccionado: Elemento?

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaElementos.delegate = self
        tablaElementos.dataSource = self

        if let cultura = cultura {
            title = cultura.nombre
            lblNombre.text = cultura.nombre
            lblRegion.text = "Región: " + cultura.region
            lblDescripcion.text = cultura.descripcion
            imgCultura.image = cultura.foto
        }
        imgCultura.layer.cornerRadius = 10
        imgCultura.clipsToBounds = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura?.elementos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaElemento", for: indexPath) as! ElementoTableViewCell
        let elemento = cultura!.elementos[indexPath.row]
        celda.lblTitulo.text = elemento.titulo
        celda.imgElemento.image = elemento.foto
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        elementoSeleccionado = cultura!.elementos[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "mostrarElemento", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarElemento" {
            let detalle = segue.destination as! DetalleElementoViewController
            detalle.elemento = elementoSeleccionado
        }
    }

}
