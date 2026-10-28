import SwiftUI

struct ContentView: View {
    // Toma el store del entorno (como useContext)
    @Environment(HabitosStore.self) private var store

    // Estado de la INTERFAZ: se queda aquí porque solo le importa a esta pantalla
    @State private var ocultarCompletados = false
    @State private var mostrarFormulario = false

    var body: some View {
        // @Bindable: permite sacar bindings ($) del store
        @Bindable var store = store

        NavigationStack {
            List {
                Section {
                    Text("Completados: \(store.totalCompletos) de \(store.habitos.count)")
                        .foregroundStyle(.secondary)
                    
                    ProgressView(value: store.progresoTotal)
                        .tint(.green)

                    if store.todosCompletos {
                        Text("¡Día perfecto! 🎉")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }

                    Toggle("Ocultar completados", isOn: $ocultarCompletados)
                    
                    Button("Completar todo", systemImage: "checkmark.circle") {
                        withAnimation {
                            store.completarTodo()
                        }
                    }
                }

                Section("Hábitos") {
                    if store.habitos.isEmpty {
                        ContentUnavailableView(
                            "Sin hábitos",
                            systemImage: "list.bullet.clipboard",
                            description: Text("Toca + para crear tu primer hábito")
                        )
                    }
                    ForEach($store.habitos) { $habito in
                        if !(ocultarCompletados && habito.estaCompleto) {
                            NavigationLink {
                                HabitoDetalle(habito: $habito)
                            } label: {
                                HabitoFila(habito: habito)
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
                                Button("Eliminar", systemImage: "trash", role: .destructive) {
                                    withAnimation {
                                        store.eliminar(habito)
                                    }
                                }
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
                            store.reiniciarTodo()
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
                NuevoHabitoView()   // ya no necesita callback, usa el store directamente
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(HabitosStore())   // ⚠️ el Preview también necesita su store
}
