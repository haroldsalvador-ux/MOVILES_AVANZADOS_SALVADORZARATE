//
//  PestanasPorRol.swift
//  Ventas
//
//  El UITabBarController "Pestañas por rol" está en Main.storyboard. Cada pestaña es un
//  Navigation Controller con su pantalla (A9, A7, A3, A4, A5, A6) y un tag:
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

        // Cuenta es una pantalla sencilla hecha por código
        let cuenta = UINavigationController(rootViewController: CuentaViewController())
        cuenta.navigationBar.prefersLargeTitles = true
        cuenta.tabBarItem = UITabBarItem(title: "Cuenta", image: UIImage(systemName: "person.crop.circle"), selectedImage: nil)

        pestanas.viewControllers = delRol + [cuenta]
        pestanas.tabBar.tintColor = UI.azul
    }
}
