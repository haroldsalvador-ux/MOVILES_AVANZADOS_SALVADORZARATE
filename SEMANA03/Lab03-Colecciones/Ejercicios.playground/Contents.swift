// Desarrollado por: Harold Salvador Zarate
import Foundation // Importa el framework Foundation para el manejo de consola e E/S

// Diccionario para almacenar los precios de los productos usando el nombre como clave
var preciosProductos: [String: Double] = [:]
// Diccionario para almacenar el stock disponible usando el nombre como clave
var stocksProductos: [String: Int] = [:]

// Solicita al usuario la cantidad inicial de productos a registrar
print("¿Cuántos productos desea registrar inicialmente en el inventario?")
// Lee el valor ingresado por consola, convierte a entero o asigna 0 por defecto
let cantidadInicial = Int(readLine() ?? "") ?? 0

// Bucle para iterar la cantidad de veces especificada por el usuario
for i in 1...cantidadInicial {
    // Solicita el nombre del producto actual
    print("\nProducto \(i) - Nombre:")
    // Captura el nombre ingresado por teclado
    let nombre = readLine() ?? ""
    
    // Solicita el precio del producto actual
    print("Precio unitario (S/.):")
    // Convierte el texto a Double o asigna 0.0 si la entrada es inválida
    let precio = Double(readLine() ?? "") ?? 0.0
    
    // Solicita la cantidad en stock del producto
    print("Cantidad en stock:")
    // Convierte la entrada a Int o asigna 0 por defecto
    let stock = Int(readLine() ?? "") ?? 0
    
    // Almacena el precio en el diccionario correspondiente
    preciosProductos[nombre] = precio
    // Almacena la cantidad en stock en el diccionario correspondiente
    stocksProductos[nombre] = stock
}

// Variable de control para mantener activo el menú interactivo
var continuarMenu = true

// Ciclo while que mantendrá desplegado el menú hasta que el usuario decida salir
while continuarMenu {
    // Imprime la barra separadora superior del menú
    print("\n" + String(repeating: "=", count: 45))
    // Muestra el título del menú principal
    print("        MENÚ DE GESTIÓN DE INVENTARIO")
    // Imprime separador del menú
    print(String(repeating: "=", count: 45))
    // Muestra la opción 1 para listar todo el inventario
    print("1) Ver inventario completo")
    // Muestra la opción 2 para buscar un producto por su nombre
    print("2) Buscar producto")
    // Muestra la opción 3 para consultar productos con bajo stock
    print("3) Ver productos con stock bajo (< 5)")
    // Muestra la opción 4 para calcular el valor total acumulado del inventario
    print("4) Calcular valor total del inventario")
    // Muestra la opción 5 para dar por finalizado el programa
    print("5) Salir")
    // Imprime la barra separadora inferior
    print(String(repeating: "-", count: 45))
    // Pide al usuario que elija una opción
    print("Seleccione una opción (1-5):")
    
    // Lee la opción seleccionada por consola
    let opcion = readLine() ?? ""
    
    // Evalúa la opción elegida mediante una estructura switch
    switch opcion {
    case "1": // Caso 1: Ver inventario completo
        print("\n--- INVENTARIO COMPLETO ---")
        // Verifica si el inventario contiene productos registrados
        if preciosProductos.isEmpty {
            // Informa que no existen registros actualmente
            print("El inventario se encuentra vacío.")
        } else {
            // Recorre el diccionario de precios obteniendo la clave (nombre) y el precio
            for (producto, precio) in preciosProductos {
                // Obtiene el stock correspondiente usando desenvolvimiento seguro (if let)
                if let stock = stocksProductos[producto] {
                    // Muestra el producto formateando su nombre, precio y cantidad en stock
                    print(String(format: "• %-15@ | Precio: S/. %7.2f | Stock: %3d unds.", producto, precio, stock))
                }
            }
        }
        
    case "2": // Caso 2: Buscar producto específico
        print("\nIngrese el nombre del producto a buscar:")
        // Lee el nombre del producto que se desea consultar
        let busqueda = readLine() ?? ""
        
        // Verifica si el producto buscado existe dentro del diccionario
        if let precio = preciosProductos[busqueda], let stock = stocksProductos[busqueda] {
            // Imprime los datos del producto hallado en el sistema
            print("\n✅ PRODUCTO ENCONTRADO:")
            print("Nombre: \(busqueda)")
            print(String(format: "Precio: S/. %.2f", precio))
            print("Stock disponible: \(stock) unidades")
        } else {
            // Muestra mensaje de error si el producto no se encuentra registrado
            print("\n❌ El producto '\(busqueda)' no existe en el inventario.")
        }
        
    case "3": // Caso 3: Alerta de productos con stock bajo
        print("\n--- ALERTA DE STOCK BAJO (< 5 unidades) ---")
        // Variable bandera para rastrear si se encontró algún producto en estado crítico
        var hayStockBajo = false
        
        // Recorre todos los productos evaluando sus cantidades en stock
        for (producto, stock) in stocksProductos {
            // Evalúa si el stock del producto actual es menor a 5 unidades
            if stock < 5 {
                // Obtiene el precio mediante unwrapping seguro para completar el reporte
                if let precio = preciosProductos[producto] {
                    // Imprime la advertencia con formato
                    print(String(format: "⚠️ %-15@ | Stock Crítico: %d unds. | Precio: S/. %.2f", producto, stock, precio))
                    // Cambia la bandera a verdadero
                    hayStockBajo = true
                }
            }
        }
        
        // Si la bandera sigue siendo falsa, confirma que el almacén está abastecido
        if !hayStockBajo {
            print("Todos los productos cuentan con un stock adecuado (≥ 5 unidades).")
        }
        
    case "4": // Caso 4: Calcular el valor total acumulado
        print("\n--- VALOR TOTAL DEL INVENTARIO ---")
        // Variable acumuladora para almacenar la suma total del dinero invertido
        var valorTotal: Double = 0.0
        
        // Recorre el inventario para multiplicar precio por cantidad de cada producto
        for (producto, precio) in preciosProductos {
            // Obtiene el stock seguro del producto actual
            if let stock = stocksProductos[producto] {
                // Multiplica el precio unitario por el total de unidades y suma al acumulador
                valorTotal += precio * Double(stock)
            }
        }
        
        // Muestra el importe total monetario del inventario formateado a 2 decimales
        print(String(format: "El valor total acumulado del inventario es: S/. %.2f", valorTotal))
        
    case "5": // Caso 5: Salir del programa
        print("\n¡Gracias por utilizar el sistema de inventario! Hasta luego.")
        // Modifica la variable de control a false para romper el bucle while
        continuarMenu = false
        
    default: // Manejo de entradas inválidas
        print("\nOpción no válida. Por favor, ingrese un número del 1 al 5.")
    }
}
