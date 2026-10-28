import SwiftUI

struct NuevoHabitoView: View {
    // dismiss: función que cierra esta hoja
    @Environment(\.dismiss) private var dismiss

    // Callback: la vista padre decide qué hacer con el hábito nuevo
    let onGuardar: (Habito) -> Void

    // Estado del formulario (cada campo tiene su @State)
    @State private var nombre = ""
    @State private var nota = ""
    @State private var frecuencia: Frecuencia = .diaria
    @State private var meta = 1
    @State private var icono = "star"

    private let iconos = [
        "star", "book", "figure.run", "drop",
        "bed.double", "leaf", "dumbbell", "brain.head.profile"
    ]

    // Validación: el nombre no puede estar vacío (ni ser solo espacios)
    private var nombreValido: Bool {
        !nombre.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private var notaValida: Bool {
        !nota.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Vista previa") {
                    HabitoFila(habito: Habito(
                        nombre: nombre.isEmpty ? "Mi hábito" : nombre,
                        icono: icono,
                        frecuencia: frecuencia,
                        meta: meta
                    ))
                }
                Section("Información") {
                    TextField("Nombre del hábito", text: $nombre)
                    if !nombreValido {
                        Text("El nombre es obligatorio")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    TextField("Nota (opcional)", text: $nota)
                    if !notaValida {
                        Text("La nota es obligatoria")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Section("Frecuencia y meta") {
                    Picker("Frecuencia", selection: $frecuencia) {
                        ForEach(Frecuencia.allCases, id: \.self) { opcion in
                            Text(opcion.rawValue).tag(opcion)
                        }
                    }
                    .pickerStyle(.segmented)

                    Stepper("Meta: \(meta)", value: $meta, in: 1...20)
                }

                Section("Ícono") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                        ForEach(iconos, id: \.self) { simbolo in
                            Image(systemName: simbolo)
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(icono == simbolo ? Color.white : Color.blue)
                                .background(icono == simbolo ? Color.blue : Color.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    icono = simbolo
                                }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Nuevo hábito")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        guardar()
                    }
                    .disabled(!nombreValido)
                }
            }
        }
    }

    private func guardar() {
        let notaLimpia = nota.trimmingCharacters(in: .whitespaces)

        let nuevo = Habito(
            nombre: nombre.trimmingCharacters(in: .whitespaces),
            icono: icono,
            frecuencia: frecuencia,
            meta: meta,
            nota: notaLimpia.isEmpty ? nil : notaLimpia
        )

        onGuardar(nuevo)   // le entrega el hábito al padre
        dismiss()          // cierra la hoja
    }
}

#Preview {
    NuevoHabitoView { habito in
        print("Guardado:", habito.nombre)
    }
}
