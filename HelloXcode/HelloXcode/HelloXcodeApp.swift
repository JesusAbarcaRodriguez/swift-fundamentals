import SwiftUI

@main
struct HelloXcodeApp: App {
    // El store se crea UNA sola vez, aquí
    @State private var store = HabitosStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)   // ← como un <Provider> en React
        }
    }
}
