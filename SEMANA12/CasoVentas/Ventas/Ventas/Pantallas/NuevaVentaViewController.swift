//
//  NuevaVentaViewController.swift
//  Ventas
//
//  A5 · Registrar venta: vendedor de la sesión (no editable), cliente, producto,
//  cantidad con stepper y stock disponible, resumen calculado y Registrar venta.
//

import UIKit

final class NuevaVentaViewController: UIViewController {

    private var cliente: Cliente?
    private var producto: Producto?

    private let vendedorEtiqueta = UI.etiqueta(estilo: .body, negrita: true)
    private let clienteBoton = UIButton(configuration: .gray())
    private let categoriaEtiqueta = UI.etiqueta(estilo: .footnote, color: .secondaryLabel)
    private let productoBoton = UIButton(configuration: .gray())
    private let stockEtiqueta = UI.etiqueta(estilo: .footnote, color: .secondaryLabel)
    private let cantidadCampo = UI.campo("Cantidad", id: "cantidad", teclado: .numberPad)
    private let stepper = UIStepper()
    private let subtotal = UI.etiqueta()
    private let descuento = UI.etiqueta()
    private let igv = UI.etiqueta()
    private let total = UI.etiqueta(estilo: .title3, negrita: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // ① vendedor automático
        vendedorEtiqueta.text = "🔒 \(Sesion.shared.usuario?.nombre ?? "")"
        vendedorEtiqueta.accessibilityIdentifier = "vendedor"

        // ② cliente y ③ producto con menú
        for (boton, id) in [(clienteBoton, "elegirCliente"), (productoBoton, "elegirProducto")] {
            boton.showsMenuAsPrimaryAction = true
            boton.contentHorizontalAlignment = .leading
            boton.accessibilityIdentifier = id
            boton.configuration?.cornerStyle = .large
        }

        // ④ cantidad con stepper
        stepper.minimumValue = 1
        stepper.maximumValue = 9999
        stepper.value = 1
        stepper.accessibilityIdentifier = "stepper"
        stepper.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.cantidadCampo.text = "\(Int(self.stepper.value))"
            self.actualizarResumen()
        }, for: .valueChanged)
        cantidadCampo.text = "1"
        cantidadCampo.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if let n = Int(self.cantidadCampo.text ?? ""), n > 0 { self.stepper.value = Double(min(n, 9999)) }
            self.actualizarResumen()
        }, for: .editingChanged)
        let filaCantidad = UI.pila([cantidadCampo, stepper], espacio: 12, eje: .horizontal)
        filaCantidad.alignment = .center

        // ⑤ resumen calculado
        subtotal.accessibilityIdentifier = "subtotal"
        descuento.accessibilityIdentifier = "descuento"
        igv.accessibilityIdentifier = "igv"
        total.accessibilityIdentifier = "total"
        let tarjeta = UI.pila([subtotal, descuento, igv, total], espacio: 6)
        tarjeta.isLayoutMarginsRelativeArrangement = true
        tarjeta.layoutMargins = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        tarjeta.backgroundColor = .secondarySystemBackground
        tarjeta.layer.cornerRadius = 12

        // ⑥ registrar
        let registrar = UI.boton("Registrar venta", id: "registrarVenta") { [weak self] in self?.registrar() }

        func titulo(_ t: String) -> UILabel { UI.etiqueta(t, estilo: .subheadline, color: .secondaryLabel) }
        let contenido = UI.pila([
            titulo("Vendedor (automático)"), vendedorEtiqueta,
            titulo("Cliente"), clienteBoton, categoriaEtiqueta,
            titulo("Producto"), productoBoton, stockEtiqueta,
            titulo("Cantidad"), filaCantidad,
            titulo("Resumen"), tarjeta, registrar,
        ], espacio: 6)
        contenido.setCustomSpacing(16, after: vendedorEtiqueta)
        contenido.setCustomSpacing(16, after: categoriaEtiqueta)
        contenido.setCustomSpacing(16, after: stockEtiqueta)
        contenido.setCustomSpacing(16, after: filaCantidad)
        contenido.setCustomSpacing(18, after: tarjeta)
        UI.formulario(en: self, contenido: contenido)
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

    private var cantidad: Int { Int(cantidadCampo.text ?? "") ?? 0 }

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

    private func registrar() {
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
