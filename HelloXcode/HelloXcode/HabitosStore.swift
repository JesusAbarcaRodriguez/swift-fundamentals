import Foundation
import Observation

// @Observable: cuando algo de aquí cambia, las vistas que lo usan se redibujan solas
@Observable
class HabitosStore {
    // Los datos
    var habitos: [Habito] = Habito.ejemplos

    // Valores calculados (antes estaban en ContentView)
    var totalCompletos: Int {
        habitos.filter { $0.estaCompleto }.count
    }

    var todosCompletos: Bool {
        !habitos.isEmpty && totalCompletos == habitos.count
    }
    
    var progresoTotal: Double {
        guard !habitos.isEmpty else { return 0 }
        return Double(totalCompletos) / Double(habitos.count)
    }

    // Acciones (la lógica vive aquí, no en las vistas)
    func agregar(_ habito: Habito) {
        habitos.append(habito)
    }

    func eliminar(_ habito: Habito) {
        habitos.removeAll { $0.id == habito.id }
    }

    func reiniciarTodo() {
        for i in habitos.indices {
            habitos[i].reiniciar()
        }
    }
    
    func completarTodo() {
        for i in habitos.indices {
            habitos[i].completados = habitos[i].meta
        }
    }
}
