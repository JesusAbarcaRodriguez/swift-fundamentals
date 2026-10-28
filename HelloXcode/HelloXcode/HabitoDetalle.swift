import SwiftUI
import SwiftData
struct HabitoDetalle: View {
    // @Bindable: nos deja sacar bindings ($habito.nombre) de un objeto @Model.
    // Es lo mismo que hicimos con el store en la Lección 6.
    @Bindable var habito: Habito

    var body: some View {
        VStack(spacing: 24) {
            // Ícono grande
            Image(systemName: habito.icono)
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 120, height: 120)
                .background(habito.estaCompleto ? Color.green : Color.blue)
                .clipShape(Circle())

            // $habito.nombre: el campo escribe directo en el hábito guardado
            TextField("Nombre", text: $habito.nombre)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)

            Text(habito.frecuencia.rawValue)
                .foregroundStyle(.secondary)

            // .formatted: convierte la fecha en texto legible ("27 oct 2026")
            Text("Creado el \(habito.fechaCreacion.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
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
        HabitoDetalle(habito: Habito.ejemplos[0])
    }
    .modelContainer(.preview)
}
