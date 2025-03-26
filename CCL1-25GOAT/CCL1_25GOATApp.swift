import SwiftUI
import SwiftData

@Model
final class Car {
    var plate: String
    var type: String
    var time: Date
    
    init(plate: String, type: String, time: Date) {
        self.plate = plate
        self.type = type
        self.time = time
    }
}

@main
struct CCL1_25GOATApp: App {
    var body: some Scene {
        WindowGroup {
            DashboardView()
        }
        // SwiftData container setup
        .modelContainer(for: Car.self)
    }
}
