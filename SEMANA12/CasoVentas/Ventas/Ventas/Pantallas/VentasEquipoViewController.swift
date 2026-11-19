//
//  VentasEquipoViewController.swift
//  Ventas
//
//  A7 · Ventas del equipo (diseñada en Main.storyboard): chips por vendedor, periodo,
//  búsqueda, nombre del vendedor por la relación venta ▸ vendedor y deslizar para Anular.
//  Al deslizar Anular se abre A8 · Anular venta con el segue "anular".
//

import UIKit

final class VentasEquipoViewController: UITableViewController, UISearchResultsUpdating {

    @IBOutlet weak var chips: ChipsView!
    @IBOutlet weak var periodo: UISegmentedControl!

    private var ventas: [Venta] = []
    private var vendedores: [Usuario] = []
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        chips.alCambiar = { [weak self] _ in self?.cargar() }
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

    @IBAction func periodoCambio(_ sender: UISegmentedControl) { cargar() }

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
            self?.performSegue(withIdentifier: "anular", sender: venta)
            listo(true)
        }
        anular.image = UIImage(systemName: "xmark.circle")
        return UISwipeActionsConfiguration(actions: [anular])
    }

    /// Pasa la venta elegida a A8 y recarga la lista cuando se anula
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anular", let destino = segue.destination as? AnulacionViewController {
            destino.venta = sender as? Venta
            destino.alAnular = { [weak self] in self?.cargar() }
        }
    }
}
