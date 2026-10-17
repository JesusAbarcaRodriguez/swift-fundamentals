import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Mis hábitos")
                    .font(.largeTitle.bold())

                ForEach(Habito.ejemplos) { habito in
                    HabitoFila(habito: habito)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
