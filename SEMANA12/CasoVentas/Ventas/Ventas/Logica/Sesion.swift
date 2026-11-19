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

    /// Entra a la app y muestra las pestañas de su rol
    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
        cambiarPantallaInicial(PestanasPorRol.crear(para: usuario))
    }

    /// Cierra la sesión y vuelve al login (pantalla inicial del storyboard)
    func cerrar() {
        usuario = nil
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
        cambiarPantallaInicial(login)
    }

    private func cambiarPantallaInicial(_ controlador: UIViewController) {
        let ventana = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first
        guard let ventana else { return }
        ventana.rootViewController = controlador
        UIView.transition(with: ventana, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}

enum Rol {
    static let vendedor = "Vendedor"
    static let supervisor = "Supervisor"
}
