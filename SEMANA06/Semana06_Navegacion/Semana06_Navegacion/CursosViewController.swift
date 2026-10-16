//
//  CursosViewController.swift
//  Semana06_Navegacion
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class CursosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaCursos: UITableView!

    var cursos: [Curso] = [
        Curso(nombre: "Programación en Móviles Avanzado", area: "Desarrollo móvil",
              descripcion: "Desarrollo de aplicaciones para iOS con Swift, UIKit y SwiftUI: interfaces, tablas, colecciones y navegación entre pantallas.",
              icono: "iphone"),
        Curso(nombre: "Desarrollo de Soluciones en la Nube", area: "Cloud",
              descripcion: "Diseño y despliegue de aplicaciones en la nube: redes, servidores, contenedores, balanceo de carga y seguridad.",
              icono: "cloud"),
        Curso(nombre: "Desarrollo de Aplicaciones Web Avanzado", area: "Desarrollo web",
              descripcion: "Construcción de aplicaciones web con Node.js, APIs y bases de datos NoSQL.",
              icono: "globe"),
        Curso(nombre: "Integración de Sistemas Empresariales", area: "Procesos de negocio",
              descripcion: "Modelado de procesos con BPMN 2.0 en Bizagi e integración de sistemas dentro de la empresa.",
              icono: "arrow.triangle.branch")
    ]

    var cursoSeleccionado: Curso?

    override func viewDidLoad() {
        super.viewDidLoad()
        tablaCursos.delegate = self
        tablaCursos.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaCurso", for: indexPath)
        let curso = cursos[indexPath.row]
        var contenido = celda.defaultContentConfiguration()
        contenido.text = curso.nombre
        contenido.secondaryText = curso.area
        contenido.image = UIImage(systemName: curso.icono)
        celda.contentConfiguration = contenido
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cursoSeleccionado = cursos[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "mostrarCurso", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarCurso" {
            let detalle = segue.destination as! DetalleCursoViewController
            detalle.curso = cursoSeleccionado
        }
    }

}
