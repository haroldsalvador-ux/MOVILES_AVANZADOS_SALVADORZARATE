//
//  SceneDelegate.swift
//  Ventas
//
//  Created by Harold Salvador Zarate on 8/11/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        // Productos, clientes y ventas de ejemplo la primera vez que se abre la app
        DatosEjemplo.cargarSiHaceFalta()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
