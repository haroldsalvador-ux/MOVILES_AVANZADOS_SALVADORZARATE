//
//  PestanasPorRol.swift
//  Ventas
//
//  El UITabBarController "Pestañas por rol" está en Main.storyboard, conectado a
//  A9, A7, A3, A4, A5 y A6. Cada pestaña tiene un tag:
//  0 = los dos roles · 1 y 2 = solo Supervisor · 3 y 4 = solo Vendedor.
//  Antes de mostrarlo se dejan solo las pestañas del rol y se agrega Cuenta.
//

import UIKit

enum PestanasPorRol {

    static func configurar(_ pestanas: UITabBarController, para usuario: Usuario) {
        let permitidas: Set<Int> = usuario.rol == Rol.supervisor
            ? [0, 1, 2]   // Resumen, Ventas, Productos, Clientes
            : [0, 3, 4]   // Productos, Clientes, Venta, Mis ventas
        let delRol = (pestanas.viewControllers ?? []).filter { permitidas.contains($0.tabBarItem.tag) }
        let cuenta = CuentaViewController()
        cuenta.tabBarItem = UITabBarItem(title: "Cuenta", image: UIImage(systemName: "person.crop.circle"), selectedImage: nil)

        // Cada pantalla va dentro de un UINavigationController para tener título, buscador y botón +
        pestanas.viewControllers = (delRol + [cuenta]).map { pantalla in
            let navegacion = UINavigationController(rootViewController: pantalla)
            navegacion.navigationBar.prefersLargeTitles = true
            navegacion.tabBarItem = pantalla.tabBarItem
            return navegacion
        }
        pestanas.tabBar.tintColor = UI.azul
    }
}
