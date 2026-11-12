//
//  MisVentasViewController.swift
//  Ventas
//
//  A6 · Mis ventas: indicadores propios (hoy y mes), Todas / Hoy / Mes,
//  búsqueda por cliente y ventas anuladas tachadas (sin botón Anular).
//

import UIKit

final class MisVentasViewController: UITableViewController, UISearchResultsUpdating {

    private var ventas: [Venta] = []
    private let hoy = TarjetaIndicador(titulo: "Mis ventas de hoy", id: "indicadorHoy")
    private let mes = TarjetaIndicador(titulo: "Mis ventas del mes", id: "indicadorMes")
    private let periodo = UISegmentedControl(items: ["Todas", "Hoy", "Mes"])
    private let buscador = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(VentaCelda.self, forCellReuseIdentifier: "Venta")

        periodo.selectedSegmentIndex = 0
        periodo.accessibilityIdentifier = "periodo"
        periodo.addAction(UIAction { [weak self] _ in self?.cargar() }, for: .valueChanged)

        let tarjetas = UI.pila([hoy, mes], espacio: 10, eje: .horizontal)
        tarjetas.distribution = .fillEqually
        tableView.tableHeaderView = UI.cabecera(UI.pila([tarjetas, periodo], espacio: 10), alto: 140)

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

    func updateSearchResults(for searchController: UISearchController) { cargar() }

    private func cargar() {
        guard let yo = Sesion.shared.usuario else { return }
        // Solo las ventas del vendedor de la sesión: predicate "vendedor == %@"
        let deHoy = Datos.ventas(de: yo, periodo: .hoy)
        let delMes = Datos.ventas(de: yo, periodo: .mes)
        hoy.valor.text = Formato.soles(Datos.sumar(deHoy))
        hoy.detalle.text = "\(deHoy.filter { !$0.anulada }.count) venta(s)"
        mes.valor.text = Formato.soles(Datos.sumar(delMes))
        mes.detalle.text = "\(delMes.filter { !$0.anulada }.count) venta(s)"
        ventas = Datos.ventas(de: yo, periodo: Periodo(rawValue: periodo.selectedSegmentIndex) ?? .todas,
                              cliente: buscador.searchBar.text ?? "")
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { ventas.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "Venta", for: indexPath) as! VentaCelda
        celda.mostrar(ventas[indexPath.row], conVendedor: false)
        return celda
    }

    // El vendedor no puede anular: ninguna fila tiene acciones al deslizar
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [])
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        ventas.isEmpty ? "No hay ventas para este filtro." : nil
    }
}
