import SwiftUI

struct ContentView: View {
    @State private var habitos = Habito.ejemplos
    @State private var ocultarCompletados = false
    @State private var mostrarFormulario = false

    private var totalCompletos: Int {
        habitos.filter { $0.estaCompleto }.count
    }

    private var todosCompletos: Bool {
        totalCompletos == habitos.count
    }

    var body: some View {
        // NavigationStack: permite navegar entre pantallas
        NavigationStack {
            List {
                // Sección 1: resumen
                Section {
                    Text("Completados: \(totalCompletos) de \(habitos.count)")
                        .foregroundStyle(.secondary)

                    if todosCompletos {
                        Text("¡Día perfecto! 🎉")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }

                    Toggle("Ocultar completados", isOn: $ocultarCompletados)
                }

                // Sección 2: los hábitos
                Section("Hábitos") {
                    ForEach($habitos) { $habito in
                        if !(ocultarCompletados && habito.estaCompleto) {
                            // NavigationLink: al tocarlo, abre otra pantalla
                            NavigationLink {
                                HabitoDetalle(habito: $habito)   // destino
                            } label: {
                                HabitoFila(habito: habito)       // lo que se ve en la lista
                            }
                            .badge(habito.faltan)
                            // Deslizar hacia la derecha →
                            .swipeActions(edge: .leading) {
                                Button("Hecho", systemImage: "checkmark") {
                                    withAnimation(.bouncy) {
                                        habito.marcarHecho()
                                    }
                                }
                                .tint(.green)
                            }
                            // Deslizar hacia la izquierda ←
                            .swipeActions(edge: .trailing) {
                                Button("Deshacer", systemImage: "arrow.uturn.backward") {
                                    withAnimation {
                                        habito.deshacer()
                                    }
                                }
                                .tint(.orange)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Mis hábitos")
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reiniciar", systemImage: "arrow.counterclockwise") {
                        withAnimation {
                            for i in habitos.indices {
                                habitos[i].reiniciar()
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Nuevo", systemImage: "plus") {
                        mostrarFormulario = true
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                NuevoHabitoView { nuevo in
                    withAnimation {
                        habitos.append(nuevo)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
