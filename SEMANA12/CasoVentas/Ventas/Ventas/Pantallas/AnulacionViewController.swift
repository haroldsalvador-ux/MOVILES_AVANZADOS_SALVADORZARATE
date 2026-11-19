//
//  AnulacionViewController.swift
//  Ventas
//
//  A8 · Anular venta (diseñada en Main.storyboard). Se abre desde A7 con el segue "anular":
//  ① resumen de la venta y aviso de que el stock se devolverá
//  ② motivo obligatorio · ③ Anular deshabilitado mientras el motivo esté vacío.
//

import UIKit

final class AnulacionViewController: UIViewController {

    @IBOutlet weak var resumen: UILabel!
    @IBOutlet weak var aviso: UILabel!
    @IBOutlet weak var motivoCampo: UITextField!
    @IBOutlet weak var anularBoton: UIButton!

    /// La venta llega desde A7 en prepare(for:sender:)
    var venta: Venta?
    /// A7 recarga su lista cuando se confirma la anulación
    var alAnular: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        UI.prepararFormulario(self)
        guard let venta else { return }
        resumen.text = """
        Cliente: \(venta.cliente?.nombre ?? "")
        Producto: \(venta.producto?.nombre ?? "") × \(venta.cantidad)
        Vendedor: \(venta.vendedor?.nombre ?? "")
        Total: \(Formato.soles(venta.total))
        """
        aviso.text = "Se devolverán \(venta.cantidad) unidad(es) al stock."
        anularBoton.isEnabled = false
    }

    /// ③ El botón se habilita solo cuando hay un motivo escrito
    @IBAction func motivoCambio(_ sender: UITextField) {
        anularBoton.isEnabled = !(motivoCampo.text ?? "").trimmingCharacters(in: .whitespaces).isEmpty
    }

    @IBAction func cancelar(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func anular(_ sender: UIButton) {
        guard let venta else { return }
        try? Datos.anular(venta, motivo: motivoCampo.text ?? "")
        dismiss(animated: true) { [alAnular] in alAnular?() }
    }
}
