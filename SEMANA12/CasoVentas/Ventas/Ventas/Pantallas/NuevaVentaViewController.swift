//
//  NuevaVentaViewController.swift
//  Ventas
//
//  A5 · Registrar venta (diseñada en Main.storyboard): vendedor de la sesión (no editable),
//  cliente, producto, cantidad con stepper y stock disponible, resumen calculado y Registrar venta.
//

import UIKit

final class NuevaVentaViewController: UIViewController {

    @IBOutlet weak var vendedorEtiqueta: UILabel!
    @IBOutlet weak var clienteBoton: UIButton!
    @IBOutlet weak var categoriaEtiqueta: UILabel!
    @IBOutlet weak var productoBoton: UIButton!
    @IBOutlet weak var stockEtiqueta: UILabel!
    @IBOutlet weak var cantidadCampo: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var subtotal: UILabel!
    @IBOutlet weak var descuento: UILabel!
    @IBOutlet weak var igv: UILabel!
    @IBOutlet weak var total: UILabel!

    private var cliente: Cliente?
    private var producto: Producto?

    override func viewDidLoad() {
        super.viewDidLoad()
        UI.prepararFormulario(self)
        // ① vendedor automático
        vendedorEtiqueta.text = "🔒 \(Sesion.shared.usuario?.nombre ?? "")"
        // ② y ③ el menú se abre al tocar el botón
        clienteBoton.showsMenuAsPrimaryAction = true
        productoBoton.showsMenuAsPrimaryAction = true
        cantidadCampo.text = "1"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        armarMenus()
        actualizarResumen()
    }

    private func armarMenus() {
        clienteBoton.menu = UIMenu(children: Datos.clientes().map { c in
            UIAction(title: c.nombre ?? "", subtitle: Datos.categoria(de: c).rawValue) { [weak self] _ in
                self?.cliente = c
                self?.actualizarResumen()
            }
        })
        productoBoton.menu = UIMenu(children: Datos.productos().map { p in
            UIAction(title: p.nombre ?? "", subtitle: "\(Formato.soles(p.precio)) · stock \(p.stock)") { [weak self] _ in
                self?.producto = p
                self?.actualizarResumen()
            }
        })
    }

    // ④ cantidad: el stepper y el campo se mantienen iguales
    @IBAction func stepperCambio(_ sender: UIStepper) {
        cantidadCampo.text = "\(Int(stepper.value))"
        actualizarResumen()
    }

    @IBAction func cantidadCambio(_ sender: UITextField) {
        if let n = Int(cantidadCampo.text ?? ""), n > 0 { stepper.value = Double(min(n, 9999)) }
        actualizarResumen()
    }

    private var cantidad: Int { Int(cantidadCampo.text ?? "") ?? 0 }

    /// ⑤ resumen calculado con las reglas de negocio
    private func actualizarResumen() {
        clienteBoton.configuration?.title = cliente?.nombre ?? "Elegir cliente"
        productoBoton.configuration?.title = producto?.nombre ?? "Elegir producto"
        let categoria = cliente.map { Datos.categoria(de: $0) } ?? .regular
        if let cliente {
            categoriaEtiqueta.text = "Categoría: \(categoria.rawValue) · comprado \(Formato.soles(Datos.totalComprado(cliente)))"
        } else {
            categoriaEtiqueta.text = "Elige un cliente"
        }
        if let producto {
            stockEtiqueta.text = "Precio \(Formato.soles(producto.precio)) · Stock disponible: \(producto.stock)"
            stockEtiqueta.textColor = Int64(cantidad) > producto.stock ? .systemRed : .secondaryLabel
        } else {
            stockEtiqueta.text = "Elige un producto"
            stockEtiqueta.textColor = .secondaryLabel
        }
        let montos = Calculo.resumen(precio: producto?.precio ?? 0, cantidad: max(cantidad, 0), categoria: categoria)
        subtotal.text = "Subtotal: \(Formato.soles(montos.subtotal))"
        descuento.text = "Descuento (\(Int(categoria.porcentajeDescuento * 100)) %): − \(Formato.soles(montos.descuento))"
        igv.text = "IGV (18 %): \(Formato.soles(montos.igv))"
        total.text = "Total: \(Formato.soles(montos.total))"
    }

    // ⑥ registrar
    @IBAction func registrar(_ sender: UIButton) {
        guard let vendedor = Sesion.shared.usuario else { return }
        view.endEditing(true)
        do {
            let venta = try Datos.registrarVenta(vendedor: vendedor, cliente: cliente, producto: producto, cantidad: cantidad)
            UI.alerta(self, "Venta registrada", "Total \(Formato.soles(venta.total)) · Stock de \(venta.producto?.nombre ?? ""): \(venta.producto?.stock ?? 0)")
            cantidadCampo.text = "1"
            stepper.value = 1
            armarMenus()
            actualizarResumen()
        } catch {
            UI.alerta(self, "No se registró la venta", error.localizedDescription)
            actualizarResumen()
        }
    }
}
