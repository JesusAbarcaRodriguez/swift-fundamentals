import Foundation

// MARK: - Modelos que llegan de la API

// Decodable: Swift sabe construir este struct a partir de JSON.
// La API manda: {"id": 954, "quote": "...", "author": "..."}
// Solo declaramos lo que nos interesa; lo demás (id) se ignora.
struct Frase: Decodable {
    let texto: String
    let autor: String

    // CodingKeys: traduce los nombres del JSON a nuestros nombres en español
    enum CodingKeys: String, CodingKey {
        case texto = "quote"
        case autor = "author"
    }
}

// Identifiable: para poder usarla directo en List / ForEach
struct Idea: Decodable, Identifiable {
    let id: Int
    let titulo: String

    enum CodingKeys: String, CodingKey {
        case id                 // se llama igual en el JSON
        case titulo = "todo"
    }
}

// La API de ideas "envuelve" la lista: {"todos": [...], "total": 254, ...}
struct RespuestaIdeas: Decodable {
    let todos: [Idea]
}

// MARK: - Errores propios

// LocalizedError: nos deja escribir un mensaje bonito para el usuario
enum APIError: LocalizedError {
    case respuestaInvalida(codigo: Int)

    var errorDescription: String? {
        switch self {
        case .respuestaInvalida(let codigo):
            return "El servidor respondió con un error (\(codigo))."
        }
    }
}

// MARK: - Servicio

struct APIServicio {
    private let base = "https://dummyjson.com"

    // async = tarda (espera a la red). throws = puede fallar.
    func fraseAleatoria() async throws -> Frase {
        try await pedir("\(base)/quotes/random")
    }

    func ideas(cantidad: Int = 10) async throws -> [Idea] {
        // skip al azar para que cada recarga traiga ideas distintas
        let saltar = Int.random(in: 0...200)
        let respuesta: RespuestaIdeas = try await pedir("\(base)/todos?limit=\(cantidad)&skip=\(saltar)")
        return respuesta.todos
    }

    // Función genérica: sirve para CUALQUIER tipo T que sea Decodable.
    // Swift deduce T por el tipo que esperas recibir.
    private func pedir<T: Decodable>(_ direccion: String) async throws -> T {
        guard let url = URL(string: direccion) else {
            throw URLError(.badURL)
        }

        // await: aquí la función se pausa hasta que llegue la respuesta
        let (datos, respuesta) = try await URLSession.shared.data(from: url)

        // URLSession NO falla con 404 o 500: hay que revisarlo a mano
        if let http = respuesta as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw APIError.respuestaInvalida(codigo: http.statusCode)
        }

        // Convierte los bytes JSON en nuestro struct (o lanza error si no encajan)
        return try JSONDecoder().decode(T.self, from: datos)
    }
}
