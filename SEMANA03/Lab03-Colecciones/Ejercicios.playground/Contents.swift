// Desarrollado por: Harold Salvador Zarate
import Foundation

// ===== TODO 10: Inventario de productos =====
var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")
let n = Int(readLine() ?? "") ?? 0

for i in 1...n {
    print("\nProducto \(i) - Nombre:")
    let nombre = readLine() ?? ""
    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0
    print("Stock:")
    let stock = Int(readLine() ?? "") ?? 0
    
    precios[nombre] = precio
    stocks[nombre] = stock
}

// TODO: Calcular valor total (precio × stock)
var valorTotalInventario: Double = 0.0

for (producto, precio) in precios {
    if let stock = stocks[producto] {
        let valorProducto = precio * Double(stock)
        valorTotalInventario += valorProducto
    }
}

print("\n===== REPORTE DE INVENTARIO =====")
print("Valor total del inventario: S/ \(valorTotalInventario)")

// TODO: Mostrar productos con stock < 5
print("\n===== PRODUCTOS CON STOCK BAJO (Menor a 5) =====")
var hayStockBajo = false

for (producto, stock) in stocks {
    if stock < 5 {
        if let precio = precios[producto] {
            print("⚠️ \(producto) - Stock: \(stock) unidades - Precio: S/ \(precio)")
            hayStockBajo = true
        }
    }
}

if !hayStockBajo {
    print("No hay productos con stock bajo.")
}
