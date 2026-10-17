import SwiftUI

struct HabitoFila: View {
    let habito: Habito   // la vista recibe un hábito para mostrar

    var body: some View {
        HStack(spacing: 16) {   // HStack = horizontal
            // Ícono
            Image(systemName: habito.icono)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(habito.estaCompleto ? Color.green : Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            // Textos y barra
            VStack(alignment: .leading, spacing: 4) {   // VStack = vertical
                Text(habito.nombre)
                    .font(.headline)
                Text(habito.frecuencia.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ProgressView(value: habito.progreso)
                    .tint(habito.estaCompleto ? Color.green : Color.blue)
            }

            Spacer()   // empuja lo siguiente hacia la derecha

            Text("\(habito.completados)/\(habito.meta)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HabitoFila(habito: Habito.ejemplos[2])
        .padding()
}
