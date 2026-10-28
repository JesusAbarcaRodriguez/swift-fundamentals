import SwiftUI

struct HabitoDetalle: View {
    // @Binding: NO es una copia, es una conexión al hábito original.
    // Si lo cambias aquí, también cambia en la lista.
    @Binding var habito: Habito

    var body: some View {
        VStack(spacing: 24) {
            // Ícono grande
            Image(systemName: habito.icono)
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 120, height: 120)
                .background(habito.estaCompleto ? Color.green : Color.blue)
                .clipShape(Circle())

            Text(habito.nombre)
                .font(.largeTitle.bold())

            Text(habito.frecuencia.rawValue)
                .foregroundStyle(.secondary)

            // Barra de progreso con etiquetas
            ProgressView(value: habito.progreso) {
                Text("Progreso")
            } currentValueLabel: {
                Text("\(habito.completados) de \(habito.meta)")
            }
            .tint(habito.estaCompleto ? Color.green : Color.blue)
            
            if habito.estaCompleto {
                Text("¡Meta cumplida! ✅")
                    .foregroundStyle(.green)
            } else {
                Text("Te faltan \(habito.faltan)")
                    .foregroundStyle(.secondary)
            }

            // if let: solo muestra la nota SI existe (no es nil)
            if let nota = habito.nota {
                Label(nota, systemImage: "note.text")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Botones
            HStack(spacing: 16) {
                Button("Deshacer", systemImage: "minus") {
                    withAnimation {
                        habito.deshacer()
                    }
                }
                .buttonStyle(.bordered)
                .disabled(habito.completados == 0)

                Button("Hecho", systemImage: "plus") {
                    withAnimation(.bouncy) {
                        habito.marcarHecho()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(habito.estaCompleto)
            }
            .controlSize(.large)

            Spacer()
        }
        .padding()
        .navigationTitle(habito.nombre)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HabitoDetalle(habito: .constant(Habito.ejemplos[0]))
    }
}
