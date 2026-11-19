//
//  ClientesViewController.swift
//  Ventas
//
//  A4 · Clientes (diseñada en Main.storyboard): botón +, fila con iniciales, nombre,
//  documento y total comprado; categoría y total calculados con las ventas no anuladas.
//

import UIKit

final class ClientesViewController: UITableViewController, UISearchResultsUpdating {

    private var clientes: [Cliente] = []
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "nuevoCliente"
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    func updateSearchResults(for searchController: UISearchController) { cargar() }

    private func cargar() {
        clientes = Datos.clientes(texto: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    @IBAction func nuevo(_ sender: UIBarButtonItem) {
        pedirDatos(de: nil)
    }

    /// Crear o editar un cliente con una alerta (todos los roles)
    private func pedirDatos(de cliente: Cliente?) {
        var mensaje = "Nombre y documento"
        if let cliente {
            let comprado = Datos.totalComprado(cliente)
            mensaje = "Total comprado: \(Formato.soles(comprado)) · Categoría: \(CategoriaCliente.desde(totalComprado: comprado).rawValue)"
        }
        let alerta = UIAlertController(title: cliente == nil ? "Nuevo cliente" : "Editar cliente", message: mensaje, preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre o razón social"; $0.text = cliente?.nombre; $0.accessibilityIdentifier = "clienteNombre" }
        alerta.addTextField {
            $0.placeholder = "DNI o RUC"; $0.text = cliente?.documento; $0.keyboardType = .numberPad
            $0.accessibilityIdentifier = "clienteDocumento"
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, unowned alerta] _ in
            guard let self else { return }
            let nombre = (alerta.textFields?[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let documento = (alerta.textFields?[1].text ?? "").trimmingCharacters(in: .whitespaces)
            guard !nombre.isEmpty, !documento.isEmpty else {
                UI.alerta(self, "Datos incompletos", "Escribe el nombre y el documento.")
                return
            }
            let destino = cliente ?? Cliente(context: Datos.contexto)
            destino.nombre = nombre
            destino.documento = documento
            try? Datos.guardar()
            self.cargar()
        })
        present(alerta, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clientes.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Cliente", for: indexPath) as! ClienteCelda
        celda.mostrar(clientes[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pedirDatos(de: clientes[indexPath.row])
    }

    // Borrar solo el supervisor; Deny lo impide si el cliente tiene ventas
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard Sesion.shared.esSupervisor else { return UISwipeActionsConfiguration(actions: []) }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, listo in
            guard let self else { return }
            let cliente = self.clientes[indexPath.row]
            if Datos.borrar(cliente) {
                self.cargar()
            } else {
                UI.alerta(self, "No se puede borrar", "\(cliente.nombre ?? "El cliente") tiene ventas registradas.")
            }
            listo(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }
}

/// Celda diseñada en el storyboard (prototipo "Cliente")
final class ClienteCelda: UITableViewCell {
    @IBOutlet weak var iniciales: UILabel!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var documento: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var categoria: UILabel!

    func mostrar(_ cliente: Cliente) {
        let comprado = Datos.totalComprado(cliente)
        let cat = CategoriaCliente.desde(totalComprado: comprado)
        iniciales.text = Formato.iniciales(cliente.nombre ?? "?")
        nombre.text = cliente.nombre
        documento.text = "Doc. \(cliente.documento ?? "")"
        total.text = Formato.soles(comprado)
        total.accessibilityIdentifier = "total_\(cliente.nombre ?? "")"
        categoria.text = cat.rawValue
        categoria.accessibilityIdentifier = "categoria_\(cliente.nombre ?? "")"
        categoria.backgroundColor = cat == .vip ? .systemPurple : (cat == .frecuente ? .systemBlue : .systemGray)
    }
}
