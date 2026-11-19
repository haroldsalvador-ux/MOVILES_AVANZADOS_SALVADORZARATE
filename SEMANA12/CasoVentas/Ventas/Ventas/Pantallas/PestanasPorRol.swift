//
//  PestanasPorRol.swift
//  Ventas
//
//  Arma el UITabBarController según el rol. Cada pestaña es un UINavigationController
//  cuya pantalla sale de Main.storyboard por su Storyboard ID (A3, A4, A5, A6, A7, A9).
//

import UIKit

enum PestanasPorRol {

    static func crear(para usuario: Usuario) -> UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        func pestana(_ pantalla: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
            let navegacion = UINavigationController(rootViewController: pantalla)
            navegacion.navigationBar.prefersLargeTitles = true
            navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
            return navegacion
        }
        func pantalla(_ id: String) -> UIViewController { storyboard.instantiateViewController(withIdentifier: id) }

        let barra = UITabBarController()
        barra.tabBar.tintColor = UI.azul
        if usuario.rol == Rol.supervisor {
            barra.viewControllers = [
                pestana(pantalla("A9"), "Resumen", "chart.bar.fill"),
                pestana(pantalla("A7"), "Ventas", "list.bullet.rectangle"),
                pestana(pantalla("A3"), "Productos", "shippingbox"),
                pestana(pantalla("A4"), "Clientes", "person.2"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle"),
            ]
        } else {
            barra.viewControllers = [
                pestana(pantalla("A3"), "Productos", "shippingbox"),
                pestana(pantalla("A4"), "Clientes", "person.2"),
                pestana(pantalla("A5"), "Venta", "cart.badge.plus"),
                pestana(pantalla("A6"), "Mis ventas", "list.bullet.rectangle"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle"),
            ]
        }
        return barra
    }
}
