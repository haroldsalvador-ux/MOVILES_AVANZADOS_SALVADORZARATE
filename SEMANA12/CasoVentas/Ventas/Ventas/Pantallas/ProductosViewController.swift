//
//  ProductosViewController.swift
//  Ventas
//
//  A3 · Productos: + (solo supervisor), búsqueda, chips de categoría (predicate),
//  stock en color y deslizar para borrar (solo supervisor; bloqueado si tiene ventas).
//

import UIKit

final class ProductosViewController: UITableViewController, UISearchResultsUpdating {

    private var productos: [Producto] = []
    private let chips = ChipsView()
    private let buscador = UISearchController(searchResultsController: nil)
    private var esSupervisor: Bool { Sesion.shared.esSupervisor }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Celda")

        // ① botón + solo para el supervisor
        if esSupervisor {
            navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
                self?.abrirFormulario(nil)
            })
            navigationItem.rightBarButtonItem?.accessibilityIdentifier = "nuevoProducto"
        }

        // ② búsqueda
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar producto"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false

        // ③ chips de categoría
        chips.alCambiar = { [weak self] _ in self?.cargar() }
        tableView.tableHeaderView = UI.cabecera(chips, alto: 52)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    private func abrirFormulario(_ producto: Producto?) {
        navigationController?.pushViewController(ProductoFormViewController(producto: producto), animated: true)
    }

    // MARK: - Tabla

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { productos.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let producto = productos[indexPath.row]
        let celda = tableView.dequeueReusableCell(withIdentifier: "Celda", for: indexPath)
        var contenido = UIListContentConfiguration.subtitleCell()
        contenido.text = producto.nombre
        contenido.secondaryText = "\(producto.categoria ?? "") · \(Formato.soles(producto.precio))"
        contenido.secondaryTextProperties.color = .secondaryLabel
        celda.contentConfiguration = contenido
        // ④ stock en color
        let insignia = UI.insignia("Stock \(producto.stock)", color: UI.colorStock(producto.stock))
        insignia.accessibilityIdentifier = "stock_\(producto.nombre ?? "")"
        celda.accessoryView = insignia
        celda.selectionStyle = esSupervisor ? .default : .none
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if esSupervisor { abrirFormulario(productos[indexPath.row]) }
    }

    // ⑤ deslizar para borrar, solo supervisor
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
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

/// Crear o editar un producto (solo supervisor)
final class ProductoFormViewController: UIViewController {
    private let producto: Producto?
    private let nombreCampo = UI.campo("Nombre", id: "productoNombre")
    private let categoriaCampo = UI.campo("Categoría", id: "productoCategoria")
    private let precioCampo = UI.campo("Precio", id: "productoPrecio", teclado: .decimalPad)
    private let stockCampo = UI.campo("Stock", id: "productoStock", teclado: .numberPad)

    init(producto: Producto?) {
        self.producto = producto
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = producto == nil ? "Nuevo producto" : "Editar producto"
        navigationItem.largeTitleDisplayMode = .never
        if let producto {
            nombreCampo.text = producto.nombre
            categoriaCampo.text = producto.categoria
            precioCampo.text = String(format: "%.2f", producto.precio)
            stockCampo.text = "\(producto.stock)"
        }
        let guardar = UI.boton("Guardar", id: "guardarProducto") { [weak self] in self?.guardar() }
        UI.formulario(en: self, contenido: UI.pila([nombreCampo, categoriaCampo, precioCampo, stockCampo, guardar]))
    }

    private func guardar() {
        let nombre = (nombreCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let categoria = (categoriaCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        guard !nombre.isEmpty, !categoria.isEmpty,
              let precio = Double((precioCampo.text ?? "").replacingOccurrences(of: ",", with: ".")), precio > 0,
              let stock = Int64(stockCampo.text ?? ""), stock >= 0 else {
            UI.alerta(self, "Datos incompletos", "Escribe nombre, categoría, un precio mayor que cero y el stock.")
            return
        }
        let destino = producto ?? Producto(context: Datos.contexto)
        destino.nombre = nombre
        destino.categoria = categoria
        destino.precio = precio
        destino.stock = stock
        try? Datos.guardar()
        navigationController?.popViewController(animated: true)
    }
}
