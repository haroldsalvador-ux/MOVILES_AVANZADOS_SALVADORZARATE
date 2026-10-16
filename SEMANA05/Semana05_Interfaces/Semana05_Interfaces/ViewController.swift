//
//  ViewController.swift
//  Semana05_Interfaces
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCodigo: UITextField!
    @IBOutlet weak var segTurno: UISegmentedControl!
    @IBOutlet weak var lblNota: UILabel!
    @IBOutlet weak var sldNota: UISlider!
    @IBOutlet weak var swNotificaciones: UISwitch!
    @IBOutlet weak var lblResultado: UILabel!
    @IBOutlet weak var txtCiclo: UITextView!

    var eventos: [String] = []

    // MARK: Ciclo de vida del ViewController

    override func loadView() {
        super.loadView()
        registrarEvento("loadView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registrarEvento("viewDidLoad")

        txtNombre.delegate = self
        txtCodigo.delegate = self
        lblNota.text = "\(Int(sldNota.value))"
        lblResultado.text = "Completa tus datos y presiona Registrar."
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registrarEvento("viewWillAppear")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        registrarEvento("viewDidAppear")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !eventos.contains(where: { $0.hasSuffix("viewWillLayoutSubviews") }) {
            registrarEvento("viewWillLayoutSubviews")
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !eventos.contains(where: { $0.hasSuffix("viewDidLayoutSubviews") }) {
            registrarEvento("viewDidLayoutSubviews")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        registrarEvento("viewWillDisappear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        registrarEvento("viewDidDisappear")
    }

    func registrarEvento(_ nombre: String) {
        let formato = DateFormatter()
        formato.dateFormat = "HH:mm:ss"
        eventos.append("\(formato.string(from: Date()))   \(nombre)")
        print("ViewController -> \(nombre)")
        txtCiclo?.text = eventos.joined(separator: "\n")
    }

    // MARK: Acciones de los controles

    @IBAction func cambiarNota(_ sender: UISlider) {
        lblNota.text = "\(Int(sender.value))"
    }

    @IBAction func registrar(_ sender: UIButton) {
        view.endEditing(true)
        let nombre = txtNombre.text ?? ""
        let codigo = txtCodigo.text ?? ""

        if nombre.isEmpty || codigo.isEmpty {
            lblResultado.textColor = .systemRed
            lblResultado.text = "Ingresa tu nombre y tu código."
            return
        }

        let turno = segTurno.titleForSegment(at: segTurno.selectedSegmentIndex) ?? ""
        let avisos = swNotificaciones.isOn ? "Sí" : "No"

        lblResultado.textColor = .label
        lblResultado.text = "Estudiante: \(nombre)\nCódigo: \(codigo)\nTurno: \(turno)\nPromedio: \(Int(sldNota.value))\nNotificaciones: \(avisos)"
    }

    @IBAction func limpiar(_ sender: UIButton) {
        txtNombre.text = ""
        txtCodigo.text = ""
        segTurno.selectedSegmentIndex = 0
        sldNota.value = 10
        lblNota.text = "10"
        swNotificaciones.isOn = true
        lblResultado.textColor = .label
        lblResultado.text = "Completa tus datos y presiona Registrar."
    }

    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtNombre {
            txtCodigo.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

}
