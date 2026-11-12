//
//  PestanasPorRol.swift
//  Ventas
//
//  UITabBarController cuyas pestañas dependen del rol.
//

import UIKit

enum PestanasPorRol {

    static func crear(para usuario: Usuario) -> UITabBarController {
        func pestana(_ pantalla: UIViewController, _ titulo: String, _ icono: String) -> UINavigationController {
            pantalla.title = titulo
            let navegacion = UINavigationController(rootViewController: pantalla)
            navegacion.navigationBar.prefersLargeTitles = true
            navegacion.tabBarItem = UITabBarItem(title: titulo, image: UIImage(systemName: icono), selectedImage: nil)
            return navegacion
        }

        let barra = UITabBarController()
        barra.tabBar.tintColor = UI.azul
        if usuario.rol == Rol.supervisor {
            barra.viewControllers = [
                pestana(ResumenViewController(), "Resumen", "chart.bar.fill"),
                pestana(VentasEquipoViewController(), "Ventas", "list.bullet.rectangle"),
                pestana(ProductosViewController(), "Productos", "shippingbox"),
                pestana(ClientesViewController(), "Clientes", "person.2"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle"),
            ]
        } else {
            let venta = pestana(NuevaVentaViewController(), "Venta", "cart.badge.plus")
            venta.topViewController?.navigationItem.title = "Nueva venta"
            barra.viewControllers = [
                pestana(ProductosViewController(), "Productos", "shippingbox"),
                pestana(ClientesViewController(), "Clientes", "person.2"),
                venta,
                pestana(MisVentasViewController(), "Mis ventas", "list.bullet.rectangle"),
                pestana(CuentaViewController(), "Cuenta", "person.crop.circle"),
            ]
        }
        return barra
    }
}
