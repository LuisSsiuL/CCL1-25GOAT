import SwiftUI
import SwiftData

//<<<<<<< Updated upstream
//struct Entries {
//    var category: String,
//        time: Date,
//        image: Data?,
//        note: String?
//}
//
//struct Cars {
//    var plate: String,
//        type: String,
//        entries: [Entries]
//    
//    var mostRecentDate: Date {
//        entries.max(by: { $0.time < $1.time })?.time ?? Date()
//=======
//<<<<<<< Updated upstream
//struct Entries {
//    var category: String,
//        time: Date,
//        image: Data?,
//        note: String?
//    var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMM yyyy"
//        return formatter.string(from: time)
//       }
//    
//}
//
//struct Cars {
//    var plate: String,
//        type: String,
//        entries: [Entries]
//=======
struct GroupedCarList: View {
    
    let car: [Car]
    
    private var groupedCar: [Date: [Car]] {
        Dictionary(grouping: car) { car in
            Calendar.current.startOfDay(for: car.mostRecentEntry)
        }
    }
    
    private var sectionDates: [Date] {
        groupedCar.keys.sorted(by: >) // sorts by newest first
    }
    
    var body: some View {
        List {
            ForEach(sectionDates, id: \.self) { date in
                carSection(date: date, groupedCar: self.groupedCar)
            }
        }.listStyle(GroupedListStyle())
    }
    
    private func carSectionHeader(for date: Date) -> some View {
        HStack {
            Text(date.formatted(.dateTime.day().month().year())).font(.caption)
            Spacer()
        }
>>>>>>> Stashed changes
    }
    
    private func carSection(date: Date, groupedCar: [Date: [Car]]) -> some View {
        // 1. Safely unwrap the cars array
        guard let cars = groupedCar[date], !cars.isEmpty else {
            // 2. Return an empty view when no cars exist
            return AnyView(EmptyView())
        }
        
        // 3. Return the actual section content
        return AnyView(
            Section(header: carSectionHeader(for: date)) {
                ForEach(cars) { car in  // Use the unwrapped 'cars' array
                    NavigationLink {
                        VehicleDetailView(vehicle: car)
                    } label: {
                        DashboardCard(cars: car, entry: car.entry)
                    }
                }
            }
        )
    }
}

struct DashboardCard: View {
    
    let cars: Cars
    let entries: [Entries]
    
    var body: some View {
        HStack {
            Image(systemName: cars.type == "Car" ? "car.side.fill" : "motorcycle.fill").foregroundStyle(.secondary)
            Text(cars.plate)
            Spacer()
            Text(cars.mostRecentDate, format: .dateTime.hour().minute()).foregroundStyle(.secondary)
        }
    }
}

struct DashboardView: View {
    
    @State private var cars = [
<<<<<<< Updated upstream
        Cars(plate: "ABC123", type: "Car", entries: [Entries(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 28, hour: 7, minute: 30))!,image: nil, note: "kaca spion pecah"), Entries(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 28, hour: 7, minute: 45))!,image: nil, note: "kaca spion pecah")]),
        Cars(plate: "DEF456", type: "Bike", entries: [Entries(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 28, hour: 8, minute: 30))!,image: nil, note: "spion kanan hilang")]),
        Cars(plate: "GHI789", type: "Car", entries: [Entries(category: "Body", time: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 28, hour: 9, minute: 30))!,image: nil, note: "panel pintu lecet")]),
        Cars(plate: "JKL012", type: "Bike", entries: [Entries(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2021, month: 7, day: 28, hour: 10, minute: 30))!,image: nil, note: "spion kiri hilang")]),
=======
        Car(plate: "ABC123", type: "Car", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 27, hour: 7, minute: 30))!, note: "kaca spion pecah"), Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 28, hour: 7, minute: 45))!, note: "kaca spion pecah")]),
        Car(plate: "DEF456", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 27, hour: 8, minute: 30))!, note: "spion kanan hilang")]),
        Car(plate: "GHI789", type: "Car", entry: [Entry(category: "Body", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 20, hour: 9, minute: 30))!, note: "panel pintu lecet")]),
        Car(plate: "JKL012", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 28, hour: 10, minute: 30))!, note: "spion kiri hilang")]),
        Car(plate: "MNO993", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 25, hour: 10, minute: 30))!, note: "spion kiri hilang"), Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 29, hour: 10, minute: 30))!, note: "spion kiri hilang")]),
>>>>>>> Stashed changes
    ]
    
    var carsSearch: [Cars] {
        guard !searchText.isEmpty else {
            return cars
        }
        return cars.filter {
            $0.plate.lowercased().contains(searchText.lowercased())
        }
    }
    
    @State var searchText: String = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                HStack {
                    Text("List Hari Ini").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal).padding(.top)
                
                HStack { // ??changeable
                    Text(Date(), style: .date)
                    Spacer()
                }.padding(.horizontal)
                
                List(carsSearch, id: \.plate) { car in
                    NavigationLink {
                        //navigate to detail page of clicked list
                        VehicleDetailView(plate: car.plate)
                    } label: {
                        DashboardCard(cars: car, entries: car.entries)
                    }
                }.scrollContentBackground(.hidden)
                    .searchable(text: $searchText, placement: .navigationBarDrawer)
                // APPLY SWIPE ACTION HERE
                
            }.background(.ultraThinMaterial)                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Welcome").font(.system(size: 20, weight: .bold, design: .default))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // to-do: open scanner page
                    } label: {
                        VStack {
                            Image(systemName: "camera.viewfinder").accessibilityHint("Camera")
                            Text("Scan").font(.footnote)
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        
                    } label: {
                        Text("+ Add New Entry").font(.system(size: 19, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .frame(width: 330, height: 36, alignment: .center)
                            .background(Color.blue)
                            .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                    }
                }
            }.toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

#Preview {
    DashboardView()
}
