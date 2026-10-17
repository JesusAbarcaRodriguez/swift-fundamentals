import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Habito.ejemplos) { habito in
                Text(habito.descripcion())
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
