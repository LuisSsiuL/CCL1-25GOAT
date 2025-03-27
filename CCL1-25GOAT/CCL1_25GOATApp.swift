import SwiftUI
import SwiftData

@Model
//<<<<<<< Updated upstream
//=======
final class Entry {
    var category: String
    var time: Date
    var image: Data?
    var note: String = ""
    
    init(category: String, time: Date, note: String = "") {
        self.category = category
        self.time = time
        self.note = note
    }
}

@Model
//>>>>>>> Stashed changes
final class Car {
    var plate: String
    var type: String
    var time: Date
    var entry: [Entry]
    
    init(plate: String, type: String, time: Date, entry: [Entry]) {
        self.plate = plate
        self.type = type
        self.time = time
        self.entry = entry
    }
    
    var mostRecentEntry: Date {
        entry.max(by: { $0.time < $1.time })?.time ?? Date()
    }
    
    var dayGroup: Date {
        return Calendar.current.startOfDay(for: mostRecentEntry)
    }
    
//    var groupedEntries: [Date: [Entry]] {
//        Dictionary(grouping: entry, by: { $0.time })
//                .mapValues { $0.sorted(by: { $0.time > $1.time }) } // Sort by most recent first
//    }
<<<<<<< Updated upstream
//>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
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
