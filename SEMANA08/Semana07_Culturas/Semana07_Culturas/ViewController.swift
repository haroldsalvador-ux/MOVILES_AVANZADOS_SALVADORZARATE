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
        celda.lblRegion.text = cultura.region
        celda.imgCultura.image = cultura.foto
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cultura = culturas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let mensaje = "Región: \(cultura.region)\n\n\(cultura.descripcion)"
        let alerta = UIAlertController(title: cultura.nombre, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ver lugares", style: .default, handler: { _ in
            self.culturaSeleccionada = cultura
            self.performSegue(withIdentifier: "mostrarDetalle", sender: self)
        }))
        alerta.addAction(UIAlertAction(title: "Cerrar", style: .cancel, handler: nil))
        present(alerta, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalle" {
            let detalle = segue.destination as! DetalleViewController
            detalle.cultura = culturaSeleccionada
        }
    }

}
