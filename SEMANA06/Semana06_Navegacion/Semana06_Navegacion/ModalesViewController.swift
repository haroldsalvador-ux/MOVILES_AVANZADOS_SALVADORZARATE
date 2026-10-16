//
//  ModalesViewController.swift
//  Semana06_Navegacion
//
//  Created by Harold David Salvador Zarat on 16/10/26.
//

import UIKit

class ModalesViewController: UIViewController {

    @IBAction func mostrarFullScreen(_ sender: UIButton) {
        abrirModal(estilo: .fullScreen, nombre: "Full Screen",
                   descripcion: "Ocupa toda la pantalla. Es un cambio completo de contexto y solo se cierra con el botón.")
    }

    @IBAction func mostrarPageSheet(_ sender: UIButton) {
        abrirModal(estilo: .pageSheet, nombre: "Page Sheet",
                   descripcion: "Se muestra como una hoja y deja ver la vista de abajo. Se puede cerrar deslizando hacia abajo.")
    }

    @IBAction func mostrarFormSheet(_ sender: UIButton) {
        abrirModal(estilo: .formSheet, nombre: "Form Sheet",
                   descripcion: "Pensado para ingresar datos. En iPad se ve centrado y más pequeño; en iPhone se parece al Page Sheet.")
    }

    func abrirModal(estilo: UIModalPresentationStyle, nombre: String, descripcion: String) {
        let ventana = storyboard?.instantiateViewController(withIdentifier: "ventanaModal") as! VentanaModalViewController
        ventana.nombreEstilo = nombre
        ventana.descripcion = descripcion
        ventana.modalPresentationStyle = estilo
        present(ventana, animated: true, completion: nil)
    }

}
