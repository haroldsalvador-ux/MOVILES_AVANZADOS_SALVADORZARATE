//
//  VentasEquipoViewController.swift
//  Ventas
//
//  A7 · Ventas del equipo (supervisor): chips por vendedor, periodo, búsqueda,
//  nombre del vendedor por la relación venta ▸ vendedor y deslizar para Anular.
//  A8 · Anulación: alerta con el resumen, motivo obligatorio y botón Anular.
//

import UIKit

final class VentasEquipoViewController: UITableViewController, UISearchResultsUpdating {

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private let chips = ChipsView()
    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let buscador = UISearchController(searchResultsController: nil)
    private weak var accionAnular: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(VentaCelda.self, forCellReuseIdentifier: "Venta")

        chips.alCambiar = { [weak self] _ in self?.cargar() }
        periodo.selectedSegmentIndex = 0
        periodo.accessibilityIdentifier = "periodo"
        periodo.addAction(UIAction { [weak self] _ in self?.cargar() }, for: .valueChanged)
        // ④ nota de la relación
        let nota = UI.etiqueta("ⓘ El vendedor de cada fila sale de la relación venta ▸ vendedor (Usuario).", estilo: .caption1, color: .secondaryLabel)
        tableView.tableHeaderView = UI.cabecera(UI.pila([chips, periodo, nota], espacio: 8), alto: 124)

        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vendedores = Datos.vendedores()
        let nombres = ["Todos"] + vendedores.map { $0.nombre ?? "" }
        if nombres != chips.opciones { chips.opciones = nombres }
        cargar()
    }

    func updateSearchResults(for searchController: UISearchController) { cargar() }

    private func cargar() {
        // ① filtro por vendedor (predicate sobre la relación)
        let vendedor = chips.seleccion == 0 ? nil : vendedores[chips.seleccion - 1]
        ventas = Datos.ventas(de: vendedor, periodo: Periodo(rawValue: periodo.selectedSegmentIndex) ?? .todas,
                              cliente: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { ventas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Venta", for: indexPath) as! VentaCelda
        celda.mostrar(ventas[indexPath.row], conVendedor: true)   // ② con el nombre del vendedor
        return celda
    }

    // ③ deslizar para Anular (solo ventas vigentes)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let venta = ventas[indexPath.row]
        guard Sesion.shared.esSupervisor, !venta.anulada else { return UISwipeActionsConfiguration(actions: []) }
        let anular = UIContextualAction(style: .destructive, title: "Anular") { [weak self] _, _, listo in
            self?.pedirMotivo(venta)
            listo(true)
        }
        anular.image = UIImage(systemName: "xmark.circle")
        return UISwipeActionsConfiguration(actions: [anular])
    }

    // MARK: - A8 · Anulación con motivo

    private func pedirMotivo(_ venta: Venta) {
        let mensaje = """
        Cliente: \(venta.cliente?.nombre ?? "")
        Producto: \(venta.producto?.nombre ?? "") × \(venta.cantidad)
        Vendedor: \(venta.vendedor?.nombre ?? "")
        Total: \(Formato.soles(venta.total))

        Se devolverán \(venta.cantidad) unidad(es) al stock.
        """
        let alerta = UIAlertController(title: "Anular venta", message: mensaje, preferredStyle: .alert)
        alerta.addTextField { campo in
            campo.placeholder = "Motivo (obligatorio)"
            campo.accessibilityIdentifier = "motivo"
            campo.addAction(UIAction { [weak self] _ in
                let texto = (campo.text ?? "").trimmingCharacters(in: .whitespaces)
                self?.accionAnular?.isEnabled = !texto.isEmpty
            }, for: .editingChanged)
        }
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        let anular = UIAlertAction(title: "Anular", style: .destructive) { [weak self, weak alerta] _ in
            let motivo = alerta?.textFields?.first?.text ?? ""
            try? Datos.anular(venta, motivo: motivo)
            self?.cargar()
        }
        anular.isEnabled = false   // deshabilitado mientras el motivo esté vacío
        alerta.addAction(anular)
        accionAnular = anular
        present(alerta, animated: true)
    }
}
