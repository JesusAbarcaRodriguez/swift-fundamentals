import Foundation
import SwiftData

// Codable: SwiftData necesita saber cómo convertir el enum para guardarlo en disco
enum Frecuencia: String, CaseIterable, Codable {
    case diaria = "Diaria"
    case semanal = "Semanal"
}

// @Model: SwiftData guarda esta clase en una base de datos.
// Tiene que ser class (no struct). final = ninguna otra clase puede heredar de ella.
// Ya no ponemos "id": @Model le da uno automáticamente (y la hace Identifiable).
@Model
final class Habito {
    var nombre: String
    var icono: String
    var frecuencia: Frecuencia
    var meta: Int
    var completados: Int = 0
    var nota: String?
    var fechaCreacion: Date = Date.now   // nuevo: para ordenar la lista

    // Las clases necesitan un init escrito a mano (los structs lo generaban solos)
    init(
        nombre: String,
        icono: String,
        frecuencia: Frecuencia,
        meta: Int,
        completados: Int = 0,
        nota: String? = nil
    ) {
        self.nombre = nombre
        self.icono = icono
        self.frecuencia = frecuencia
        self.meta = meta
        self.completados = completados
        self.nota = nota
        self.fechaCreacion = .now
    }

    // Propiedades calculadas: igual que antes
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

    // Sin "mutating": en una class los métodos pueden cambiar propiedades directamente
    func marcarHecho() {
        if !estaCompleto {
            completados += 1
        }
    }

    func reiniciar() {
        completados = 0
    }

    func deshacer() {
        if completados > 0 {
            completados -= 1
        }
    }

    func descripcion() -> String {
        let textoNota = nota ?? "Sin nota"
        return "\(nombre) (\(frecuencia.rawValue)): \(completados)/\(meta) · \(textoNota)"
    }
}

extension Habito {
    // "static var { }" en vez de "static let =":
    // crea hábitos NUEVOS cada vez que lo lees. Un mismo objeto
    // no puede meterse en dos bases de datos distintas (por ejemplo, en dos Previews).
    static var ejemplos: [Habito] {
        [
            Habito(nombre: "Leer", icono: "book", frecuencia: .diaria, meta: 1, nota: "10 páginas"),
            Habito(nombre: "Ejercicio", icono: "figure.run", frecuencia: .semanal, meta: 3),
            Habito(nombre: "Tomar agua", icono: "drop", frecuencia: .diaria, meta: 8, completados: 5)
        ]
    }
}
