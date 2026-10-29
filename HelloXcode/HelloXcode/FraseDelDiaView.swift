import SwiftUI

struct FraseDelDiaView: View {
    // Enum con "valores asociados": cada estado lleva sus propios datos.
    // Así es imposible tener "cargando" y "error" a la vez.
    enum Estado {
        case cargando
        case listo(Frase)
        case error(String)
    }

    @State private var estado: Estado = .cargando
    private let api = APIServicio()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch estado {
            case .cargando:
                HStack {
                    ProgressView()
                    Text("Buscando inspiración…")
                        .foregroundStyle(.secondary)
                }

            case .listo(let frase):
                Text("“\(frase.texto)”")
                    .font(.body.italic())
                Text("— \(frase.autor)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                ShareLink(item: "“\(frase.texto)” — \(frase.autor)") {
                    Label("Compartir", systemImage: "square.and.arrow.up")
                }
                .font(.caption)
                .buttonStyle(.borderless)

            case .error(let mensaje):
                Label(mensaje, systemImage: "wifi.exclamationmark")
                    .foregroundStyle(.red)
            }

            Button("Otra frase", systemImage: "arrow.clockwise") {
                // Un botón no es async: Task { } abre un "espacio" donde sí podemos usar await
                Task { await cargar() }
            }
            .font(.caption)
            .buttonStyle(.borderless)   // dentro de List, evita que toda la fila sea el botón
            .disabled(estaCargando)
        }
        // .task: corre al aparecer la vista (como useEffect con [])
        // y se CANCELA sola si la vista desaparece.
        .task {
            // Solo carga si aún no hay frase (al volver del detalle no pide otra)
            if estaCargando {
                await cargar()
            }
        }
    }

    // "if case": pregunta si el enum está en un caso concreto
    private var estaCargando: Bool {
        if case .cargando = estado { return true }
        return false
    }

    private func cargar() async {
        estado = .cargando
        try? await Task.sleep(for: .seconds(2))
        do {
            let frase = try await api.fraseAleatoria()
            withAnimation {
                estado = .listo(frase)
            }
        } catch {
            // Si la tarea se canceló (la vista se fue), no es un error real
            if Task.isCancelled { return }
            estado = .error(error.localizedDescription)
        }
    }
}

#Preview {
    List {
        FraseDelDiaView()
    }
}
