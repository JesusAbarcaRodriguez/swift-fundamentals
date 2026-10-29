import SwiftUI
import SwiftData

struct IdeasView: View {
    @Environment(\.modelContext) private var context

    @State private var ideas: [Idea] = []
    @State private var cargando = false
    @State private var mensajeError: String?
    @State private var agregadas: Set<Int> = []   // ids de ideas ya convertidas en hábito

    private let api = APIServicio()
    
    // Binding hecho a mano: true si hay error Y ya hay ideas en pantalla
    private var mostrarAlerta: Binding<Bool> {
        Binding(
            get: { mensajeError != nil && !ideas.isEmpty },
            set: { if !$0 { mensajeError = nil } }   // al cerrar la alerta, borra el error
        )
    }

    var body: some View {
        List(ideas) { idea in
            HStack {
                Text(idea.titulo)
                Spacer()
                if agregadas.contains(idea.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title2)
                } else {
                    Button("Agregar", systemImage: "plus.circle") {
                        agregar(idea)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    .font(.title2)
                }
            }
        }
        .navigationTitle("Ideas")
        // overlay: dibuja algo ENCIMA de la lista (spinner o error)
        .overlay {
            if cargando && ideas.isEmpty {
                ProgressView("Cargando ideas…")
            } else if let mensajeError, ideas.isEmpty {
                ContentUnavailableView {
                    Label("Sin conexión", systemImage: "wifi.slash")
                } description: {
                    Text(mensajeError)
                } actions: {
                    Button("Reintentar") {
                        Task { await cargar() }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .task {
            if ideas.isEmpty {
                await cargar()
            }
        }
        // Deslizar hacia abajo para recargar. Espera a que cargar() termine.
        .refreshable {
            await cargar()
        }
        
        .alert("No se pudo recargar", isPresented: mostrarAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(mensajeError ?? "")
        }
    }

    private func cargar() async {
        cargando = true
        mensajeError = nil
        // defer: se ejecuta al SALIR de la función, pase lo que pase (como finally)
        defer { cargando = false }

        do {
            let nuevas = try await api.ideas()
            withAnimation {
                ideas = nuevas
            }
        } catch {
            if Task.isCancelled { return }
            mensajeError = error.localizedDescription
        }
    }

    private func agregar(_ idea: Idea) {
        let habito = Habito(
            nombre: idea.titulo,
            icono: "lightbulb",
            frecuencia: .diaria,
            meta: 1
        )
        withAnimation {
            context.insert(habito)       // se guarda en SwiftData
            agregadas.insert(idea.id)
        }
    }
}

#Preview {
    NavigationStack {
        IdeasView()
    }
    .modelContainer(.preview)
}
