//
//  MisVentasViewController.swift
//  Ventas
//
//  A6 · Mis ventas (diseñada en Main.storyboard): indicadores propios (hoy y mes),
//  Todas / Hoy / Mes, búsqueda por cliente y ventas anuladas tachadas (sin botón Anular).
//

import UIKit

final class MisVentasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    /// Lista diseñada en el storyboard debajo de la cabecera
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var hoyValor: UILabel!
    @IBOutlet weak var hoyDetalle: UILabel!
    @IBOutlet weak var mesValor: UILabel!
    @IBOutlet weak var mesDetalle: UILabel!
    @IBOutlet weak var periodo: UISegmentedControl!

    private var ventas: [Venta] = []
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        buscador.searchResultsUpdater = self
        buscador.obscuresBackgroundDuringPresentation = false
        buscador.searchBar.placeholder = "Buscar por cliente"
        navigationItem.searchController = buscador
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargar()
    }

    @IBAction func periodoCambio(_ sender: UISegmentedControl) { cargar() }

    func updateSearchResults(for searchController: UISearchController) { cargar() }

    private func cargar() {
        guard let yo = Sesion.shared.usuario else { return }
        // Solo las ventas del vendedor de la sesión: predicate "vendedor == %@"
        let deHoy = Datos.ventas(de: yo, periodo: .hoy)
        let delMes = Datos.ventas(de: yo, periodo: .mes)
        hoyValor.text = Formato.soles(Datos.sumar(deHoy))
        hoyDetalle.text = "\(deHoy.filter { !$0.anulada }.count) venta(s)"
        mesValor.text = Formato.soles(Datos.sumar(delMes))
        mesDetalle.text = "\(delMes.filter { !$0.anulada }.count) venta(s)"
        ventas = Datos.ventas(de: yo, periodo: Periodo(rawValue: periodo.selectedSegmentIndex) ?? .todas,
                              cliente: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { ventas.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Venta", for: indexPath) as! VentaCelda
        celda.mostrar(ventas[indexPath.row], conVendedor: false)
        return celda
    }

    // El vendedor no puede anular: ninguna fila tiene acciones al deslizar
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [])
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        ventas.isEmpty ? "No hay ventas para este filtro." : nil
    }
}
