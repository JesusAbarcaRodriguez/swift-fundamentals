import SwiftUI

struct ContentView: View {
    // @State: datos que la vista "recuerda" y que, al cambiar, redibujan la pantalla
    @State private var habitos = Habito.ejemplos
    @State private var ocultarCompletados = false

    // Propiedad calculada: cuenta los hábitos completos
    private var totalCompletos: Int {
        habitos.filter { $0.estaCompleto }.count
    }
    
    private var todosCompletos: Bool {
        totalCompletos == habitos.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Mis hábitos")
                    .font(.largeTitle.bold())

                Text("Completados: \(totalCompletos) de \(habitos.count)")
                    .foregroundStyle(.secondary)
                
                if todosCompletos {
                    Text("¡Día perfecto! 🎉")
                        .font(.title2.bold())
                        .foregroundStyle(.green)
                }

                Toggle("Ocultar completados", isOn: $ocultarCompletados)

                ForEach($habitos) { $habito in
                    if !(ocultarCompletados && habito.estaCompleto) {
                        Button {
                            withAnimation(.bouncy) {
                                habito.marcarHecho()
                            }
                        } label: {
                            HabitoFila(habito: habito)
                        }
                        .buttonStyle(.plain)
                        .contextMenu {
                            Button("Deshacer", systemImage: "arrow.uturn.backward") {
                                withAnimation {
                                    habito.deshacer()
                                }
                            }
                        }
                    }
                }

                Button("Reiniciar todo", role: .destructive) {
                    withAnimation {
                        for i in habitos.indices {
                            habitos[i].reiniciar()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
