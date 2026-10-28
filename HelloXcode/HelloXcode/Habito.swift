import Foundation

// enum: un tipo con opciones fijas
enum Frecuencia: String, CaseIterable {
    case diaria = "Diaria"
    case semanal = "Semanal"
}

// struct: un "molde" para crear datos
struct Habito: Identifiable {
    let id = UUID()            // let = constante, nunca cambia
    var nombre: String         // var = variable, puede cambiar
    var icono: String
    var frecuencia: Frecuencia
    var meta: Int
    var completados: Int = 0   // valor por defecto
    var nota: String?          // ? = opcional, puede ser nil (vacío)

    // Propiedad calculada: se calcula cada vez que la lees
    var progreso: Double {
        guard meta > 0 else { return 0 }
        return min(Double(completados) / Double(meta), 1.0)
    }

    var estaCompleto: Bool {
        completados >= meta
    }
    
    var faltan: Int {
        max(meta - completados, 0)
    }

    // mutating: la función puede modificar el struct
    mutating func marcarHecho() {
        if !estaCompleto {
            completados += 1
        }
    }
    
    mutating func reiniciar() {
        completados = 0
    }
    
    mutating func deshacer() {
        if completados > 0 {
            completados -= 1
        }
    }

    func descripcion() -> String {
        let textoNota = nota ?? "Sin nota"   // ?? = valor si es nil
        return "\(nombre) (\(frecuencia.rawValue)): \(completados)/\(meta) · \(textoNota)"
    }
}

// extension: agrega cosas a un tipo que ya existe
extension Habito {
    static let ejemplos: [Habito] = [
        Habito(nombre: "Leer", icono: "book", frecuencia: .diaria, meta: 1, nota: "10 páginas"),
        Habito(nombre: "Ejercicio", icono: "figure.run", frecuencia: .semanal, meta: 3),
        Habito(nombre: "Tomar agua", icono: "drop", frecuencia: .diaria, meta: 8, completados: 5)
    ]
}
