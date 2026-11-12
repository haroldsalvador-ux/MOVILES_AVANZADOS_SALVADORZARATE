//
//  ClientesViewController.swift
//  Ventas
//
//  A4 · Clientes: botón +, fila con iniciales, nombre, documento y total comprado;
//  categoría y total calculados con las ventas no anuladas.
//

import UIKit

final class ClientesViewController: UITableViewController, UISearchResultsUpdating {

    private var clientes: [Cliente] = []
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ClienteCelda.self, forCellReuseIdentifier: "Cliente")
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(ClienteFormViewController(cliente: nil), animated: true)
        })
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { clientes.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Cliente", for: indexPath) as! ClienteCelda
        celda.mostrar(clientes[indexPath.row])
        return celda
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(ClienteFormViewController(cliente: clientes[indexPath.row]), animated: true)
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

final class ClienteCelda: UITableViewCell {
    private let iniciales = UI.etiqueta(estilo: .headline, color: .white, negrita: true)
    private let circulo = UIView()
    private let nombre = UI.etiqueta(estilo: .headline)
    private let documento = UI.etiqueta(estilo: .subheadline, color: .secondaryLabel)
    private let total = UI.etiqueta(estilo: .subheadline, negrita: true)
    private let categoria = UI.insignia("", color: .systemGray)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        circulo.backgroundColor = UI.azul
        circulo.layer.cornerRadius = 22
        circulo.addSubview(iniciales)
        iniciales.textAlignment = .center
        iniciales.translatesAutoresizingMaskIntoConstraints = false
        circulo.translatesAutoresizingMaskIntoConstraints = false
        total.textAlignment = .right
        let derecha = UI.pila([total, categoria], espacio: 4)
        derecha.alignment = .trailing
        let centro = UI.pila([nombre, documento], espacio: 2)
        let fila = UI.pila([circulo, centro, derecha], espacio: 12, eje: .horizontal)
        fila.alignment = .center
        contentView.addSubview(fila)
        fila.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circulo.widthAnchor.constraint(equalToConstant: 44),
            circulo.heightAnchor.constraint(equalToConstant: 44),
            iniciales.centerXAnchor.constraint(equalTo: circulo.centerXAnchor),
            iniciales.centerYAnchor.constraint(equalTo: circulo.centerYAnchor),
            fila.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            fila.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            fila.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            fila.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
        derecha.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

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
        categoria.invalidateIntrinsicContentSize()
    }
}

/// Crear o editar un cliente
final class ClienteFormViewController: UIViewController {
    private let cliente: Cliente?
    private let nombreCampo = UI.campo("Nombre o razón social", id: "clienteNombre")
    private let documentoCampo = UI.campo("DNI o RUC", id: "clienteDocumento", teclado: .numberPad)

    init(cliente: Cliente?) {
        self.cliente = cliente
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no se usa") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = cliente == nil ? "Nuevo cliente" : "Editar cliente"
        navigationItem.largeTitleDisplayMode = .never
        nombreCampo.text = cliente?.nombre
        documentoCampo.text = cliente?.documento
        var vistas: [UIView] = [nombreCampo, documentoCampo]
        if let cliente {
            let comprado = Datos.totalComprado(cliente)
            vistas.append(UI.etiqueta("Total comprado: \(Formato.soles(comprado)) · Categoría: \(CategoriaCliente.desde(totalComprado: comprado).rawValue)", estilo: .subheadline, color: .secondaryLabel))
        }
        vistas.append(UI.boton("Guardar", id: "guardarCliente") { [weak self] in self?.guardar() })
        UI.formulario(en: self, contenido: UI.pila(vistas))
    }

    private func guardar() {
        let nombre = (nombreCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        let documento = (documentoCampo.text ?? "").trimmingCharacters(in: .whitespaces)
        guard !nombre.isEmpty, !documento.isEmpty else {
            UI.alerta(self, "Datos incompletos", "Escribe el nombre y el documento.")
            return
        }
        let destino = cliente ?? Cliente(context: Datos.contexto)
        destino.nombre = nombre
        destino.documento = documento
        try? Datos.guardar()
        navigationController?.popViewController(animated: true)
    }
}
