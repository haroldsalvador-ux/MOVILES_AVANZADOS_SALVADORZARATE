//
//  ProductosViewController.swift
//  Ventas
//
//  A3 · Productos (diseñada en Main.storyboard): + (solo supervisor), búsqueda,
//  chips de categoría (predicate), stock en color y deslizar para borrar
//  (solo supervisor; bloqueado si tiene ventas).
//

import UIKit

final class ProductosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    /// Lista diseñada en el storyboard debajo de la cabecera
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var chips: ChipsView!

    private var productos: [Producto] = []
    private let buscador = UISearchController(searchResultsController: nil)
    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()
        // ① el botón + del storyboard solo queda para el supervisor
        if esSupervisor {
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "nuevoProducto"
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        // ② búsqueda
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
        // ③ chips de categoría
        chips.alCambiar = { [weak self] _ in self?.cargar() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refrescar()
    }

    /// Vuelve a leer las categorías (pueden cambiar al crear un producto) y la lista
    private func refrescar() {
        let actual = chips.seleccion < chips.opciones.count ? chips.opciones[chips.seleccion] : "Todas"
        chips.opciones = ["Todas"] + Datos.categorias()
        if let i = chips.opciones.firstIndex(of: actual), i != chips.seleccion { chips.elegir(i) }
        cargar()
    }

    func updateSearchResults(for searchController: UISearchController) { cargar() }

    private func cargar() {
        let texto = buscador.searchBar.text ?? ""
        let categoria = chips.seleccion == 0 ? nil : chips.opciones[chips.seleccion]
        productos = Datos.productos(texto: texto, categoria: categoria)
        tableView.reloadData()
    }

    @IBAction func nuevo(_ sender: UIBarButtonItem) {
        pedirDatos(de: nil)
    }

    /// Crear o editar un producto con una alerta de 4 campos (solo supervisor)
    private func pedirDatos(de producto: Producto?) {
        let alerta = UIAlertController(title: producto == nil ? "Nuevo producto" : "Editar producto",
                                       message: "Nombre, categoría, precio y stock", preferredStyle: .alert)
        alerta.addTextField { $0.placeholder = "Nombre"; $0.text = producto?.nombre; $0.accessibilityIdentifier = "productoNombre" }
        alerta.addTextField { $0.placeholder = "Categoría"; $0.text = producto?.categoria; $0.accessibilityIdentifier = "productoCategoria" }
        alerta.addTextField {
            $0.placeholder = "Precio"; $0.keyboardType = .decimalPad; $0.accessibilityIdentifier = "productoPrecio"
            if let producto { $0.text = String(format: "%.2f", producto.precio) }
        }
        alerta.addTextField {
            $0.placeholder = "Stock"; $0.keyboardType = .numberPad; $0.accessibilityIdentifier = "productoStock"
            if let producto { $0.text = "\(producto.stock)" }
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alerta.addAction(UIAlertAction(title: "Guardar", style: .default) { [weak self, unowned alerta] _ in
            guard let self else { return }
            let campos = alerta.textFields ?? []
            let nombre = (campos[0].text ?? "").trimmingCharacters(in: .whitespaces)
            let categoria = (campos[1].text ?? "").trimmingCharacters(in: .whitespaces)
            guard !nombre.isEmpty, !categoria.isEmpty,
                  let precio = Double((campos[2].text ?? "").replacingOccurrences(of: ",", with: ".")), precio > 0,
                  let stock = Int64(campos[3].text ?? ""), stock >= 0 else {
                UI.alerta(self, "Datos incompletos", "Escribe nombre, categoría, un precio mayor que cero y el stock.")
                return
            }
            let destino = producto ?? Producto(context: Datos.contexto)
            destino.nombre = nombre
            destino.categoria = categoria
            destino.precio = precio
            destino.stock = stock
            try? Datos.guardar()
            self.refrescar()
        })
        present(alerta, animated: true)
    }

    // MARK: - Tabla

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { productos.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Producto", for: indexPath) as! ProductoCelda
        celda.mostrar(productos[indexPath.row])
        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if esSupervisor { pedirDatos(de: productos[indexPath.row]) }
    }

    // ⑤ deslizar para borrar, solo supervisor
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard esSupervisor else { return UISwipeActionsConfiguration(actions: []) }
        let borrar = UIContextualAction(style: .destructive, title: "Borrar") { [weak self] _, _, listo in
            guard let self else { return }
            let producto = self.productos[indexPath.row]
            if Datos.borrar(producto) {
                self.cargar()
            } else {
                UI.alerta(self, "No se puede borrar", "\(producto.nombre ?? "El producto") tiene ventas registradas.")
            }
            listo(true)
        }
        return UISwipeActionsConfiguration(actions: [borrar])
    }
}

/// Celda diseñada en el storyboard (prototipo "Producto")
final class ProductoCelda: UITableViewCell {
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var stock: UILabel!

    func mostrar(_ producto: Producto) {
        nombre.text = producto.nombre
        detalle.text = "\(producto.categoria ?? "") · \(Formato.soles(producto.precio))"
        // ④ stock en color
        stock.text = "Stock \(producto.stock)"
        stock.backgroundColor = UI.colorStock(producto.stock)
        stock.accessibilityIdentifier = "stock_\(producto.nombre ?? "")"
    }
}
