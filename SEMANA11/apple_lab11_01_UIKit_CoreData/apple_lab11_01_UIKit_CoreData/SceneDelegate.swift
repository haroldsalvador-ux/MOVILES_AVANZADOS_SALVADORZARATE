//
//  SceneDelegate.swift
//  apple_lab11_01_UIKit_CoreData
//
//  Created by Harold Salvador Zarate on 5/11/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Guarda los cambios pendientes de Core Data al pasar a segundo plano
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
