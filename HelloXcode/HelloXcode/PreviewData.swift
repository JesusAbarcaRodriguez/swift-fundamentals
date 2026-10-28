import SwiftData

extension ModelContainer {
    // Una base de datos que vive SOLO en memoria, para los Previews.
    // Se borra sola y no toca los datos reales de la app.
    static var preview: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)

        // try! = "si esto falla, deja que la app se caiga".
        // Aquí está bien porque es solo para Previews.
        let container = try! ModelContainer(for: Habito.self, configurations: config)

        for habito in Habito.ejemplos {
            container.mainContext.insert(habito)
        }
        return container
    }
}
