import SwiftUI
import SwiftData

struct ContentView: View {
    // @Query: lee los hábitos de la base de datos y redibuja la vista
    // sola cuando cambian (como un useLiveQuery).
    @Query(sort: \Habito.fechaCreacion) private var habitos: [Habito]

    // modelContext: la "conexión" para insertar y borrar
    @Environment(\.modelContext) private var context

    @State private var ocultarCompletados = false
    @State private var mostrarFormulario = false

    // Lo que antes calculaba el store, ahora vive aquí
    private var totalCompletos: Int {
        habitos.filter { $0.estaCompleto }.count
    }

    private var todosCompletos: Bool {
        !habitos.isEmpty && totalCompletos == habitos.count
    }

    private var progresoTotal: Double {
        guard !habitos.isEmpty else { return 0 }
        return Double(totalCompletos) / Double(habitos.count)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Completados: \(totalCompletos) de \(habitos.count)")
                        .foregroundStyle(.secondary)

                    ProgressView(value: progresoTotal)
                        .tint(.green)

                    if todosCompletos {
                        Text("¡Día perfecto! 🎉")
                            .font(.title3.bold())
                            .foregroundStyle(.green)
                    }

                    Toggle("Ocultar completados", isOn: $ocultarCompletados)

                    Button("Completar todo", systemImage: "checkmark.circle") {
                        withAnimation {
                            completarTodo()
                        }
                    }
                }

                Section("Hábitos") {
                    if habitos.isEmpty {
                        // Esta forma de ContentUnavailableView tiene 3 bloques:
                        // el título, la descripción y las acciones (botones)
                        ContentUnavailableView {
                            Label("Sin hábitos", systemImage: "list.bullet.clipboard")
                        } description: {
                            Text("Toca + para crear tu primer hábito")
                        } actions: {
                            Button("Cargar ejemplos", systemImage: "sparkles") {
                                withAnimation {
                                    cargarEjemplos()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    // Ya no hay $: cada habito es una referencia al objeto real
                    ForEach(habitos) { habito in
                        if !(ocultarCompletados && habito.estaCompleto) {
                            NavigationLink {
                                HabitoDetalle(habito: habito)
                            } label: {
                                HabitoFila(habito: habito)
                            }
                            .badge(habito.faltan)
                            .swipeActions(edge: .leading) {
                                Button("Hecho", systemImage: "checkmark") {
                                    withAnimation(.bouncy) {
                                        habito.marcarHecho()   // se guarda solo
                                    }
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button("Eliminar", systemImage: "trash", role: .destructive) {
                                    withAnimation {
                                        context.delete(habito)   // lo borra de la base de datos
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
                            reiniciarTodo()
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
                NuevoHabitoView()
            }
        }
    }

    // Acciones (antes estaban en el store)
    private func reiniciarTodo() {
        for habito in habitos {
            habito.reiniciar()
        }
    }

    private func completarTodo() {
        for habito in habitos {
            habito.completados = habito.meta
        }
    }
    
    
    private func cargarEjemplos() {
        // Habito.ejemplos crea 3 hábitos nuevos cada vez que lo lees
        for habito in Habito.ejemplos {
            context.insert(habito)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(.preview)   // base de datos de mentira con los 3 ejemplos
}
