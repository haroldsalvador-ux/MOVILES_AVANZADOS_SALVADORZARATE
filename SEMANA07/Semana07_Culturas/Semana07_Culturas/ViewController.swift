//
//  ViewController.swift
//  Semana07_Culturas
//
//  Created by Harold David Salvador Zarat on 15/10/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaCulturas: UITableView!

    var culturas: [Cultura] = [
        Cultura(nombre: "Caral", region: "Lima (valle de Supe)",
                descripcion: "Considerada la civilización más antigua de América, se desarrolló alrededor del 3000 a.C. Destaca por su ciudad sagrada con pirámides, plazas circulares y una sociedad organizada sin uso de armas.",
                foto: UIImage(named: "caral")),
        Cultura(nombre: "Chavín", region: "Áncash (Chavín de Huántar)",
                descripcion: "Cultura de los Andes centrales famosa por su templo de piedra con galerías subterráneas, el Lanzón monolítico y las cabezas clavas. Tuvo gran influencia religiosa en todo el territorio.",
                foto: UIImage(named: "chavin")),
        Cultura(nombre: "Paracas", region: "Ica (península de Paracas)",
                descripcion: "Reconocida por sus finos mantos textiles, las trepanaciones craneanas y sus necrópolis. Fue una de las culturas más avanzadas en el trabajo de tejidos del antiguo Perú.",
                foto: UIImage(named: "paracas")),
        Cultura(nombre: "Nazca", region: "Ica (valle de Nazca)",
                descripcion: "Conocida mundialmente por las líneas y geoglifos trazados en el desierto. También construyeron acueductos subterráneos y elaboraron una cerámica policroma muy colorida.",
                foto: UIImage(named: "nazca")),
        Cultura(nombre: "Moche", region: "La Libertad y Lambayeque",
                descripcion: "Cultura de la costa norte destacada por su cerámica escultórica (huacos retrato), la orfebrería y las huacas del Sol y de la Luna. A ella pertenece el Señor de Sipán.",
                foto: UIImage(named: "moche")),
        Cultura(nombre: "Wari", region: "Ayacucho",
                descripcion: "Primer estado expansivo de los Andes. Construyó centros administrativos planificados y una red de caminos que luego aprovecharon los incas.",
                foto: UIImage(named: "wari")),
        Cultura(nombre: "Chimú", region: "La Libertad (Chan Chan)",
                descripcion: "Se desarrolló en la costa norte y tuvo como capital a Chan Chan, la ciudad de barro más grande de América. Fueron expertos orfebres y construyeron grandes canales de riego.",
                foto: UIImage(named: "chimu")),
        Cultura(nombre: "Inca", region: "Cusco",
                descripcion: "Formaron el Tahuantinsuyo, el imperio más grande de América precolombina. Destacan por su arquitectura en piedra como Machu Picchu, el Qhapaq Ñan y la organización del ayllu.",
                foto: UIImage(named: "inca"))
    ]

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
