//
//  Sesion.swift
//  Ventas
//
//  Recuerda al usuario conectado mientras la app está abierta.
//

import UIKit

final class Sesion {
    /// Un único objeto compartido por toda la app
    static let shared = Sesion()
    private init() {}

    /// Usuario conectado (nil = nadie inició sesión)
    var usuario: Usuario?

    var esSupervisor: Bool { usuario?.rol == Rol.supervisor }

    /// Cierra la sesión: borra el usuario y vuelve a A1 Login
    /// (cierra las pantallas que se presentaron encima del login)
    func cerrar() {
        usuario = nil
        let ventana = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first
        let raiz = ventana?.rootViewController
        raiz?.dismiss(animated: true)
        // Si se entró desde A2, el Navigation Controller vuelve a A1
        (raiz as? UINavigationController)?.popToRootViewController(animated: false)
    }
}

enum Rol {
    static let vendedor = "Vendedor"
    static let supervisor = "Supervisor"
}
