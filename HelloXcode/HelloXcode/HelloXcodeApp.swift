import SwiftUI
import SwiftData

@main
struct HelloXcodeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Crea (o abre) la base de datos y la comparte con todas las vistas.
        // Reemplaza a nuestro antiguo .environment(store)
        .modelContainer(for: Habito.self)
    }
}
