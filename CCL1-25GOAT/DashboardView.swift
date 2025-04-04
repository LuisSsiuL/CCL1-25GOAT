import SwiftUI
import SwiftData

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
    
    //struct ver
    let cars: Car
    let entry: [Entry]
    
    var body: some View {
        HStack {
            Image(systemName: cars.type == "Car" ? "car.side.fill" : "motorcycle.fill").foregroundStyle(.secondary)
            Text(cars.plate)
            Spacer()
            Text(cars.mostRecentEntry, format: .dateTime.hour().minute()).foregroundStyle(.secondary)
        }
    }
}

struct DashboardView: View {
    
    @State private var cars = [
        Car(plate: "ABC123", type: "Car", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 27, hour: 7, minute: 30))!, note: "kaca spion pecah"), Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 28, hour: 7, minute: 45))!, note: "kaca spion pecah")]),
        Car(plate: "DEF456", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 27, hour: 8, minute: 30))!, note: "spion kanan hilang")]),
        Car(plate: "GHI789", type: "Car", entry: [Entry(category: "Body", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 20, hour: 9, minute: 30))!, note: "panel pintu lecet")]),
        Car(plate: "JKL012", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 28, hour: 10, minute: 30))!, note: "spion kiri hilang")]),
        Car(plate: "MNO993", type: "Bike", entry: [Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 25, hour: 10, minute: 30))!, note: "spion kiri hilang"), Entry(category: "Side Mirror", time: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 29, hour: 10, minute: 30))!, note: "spion kiri hilang")]),
    ]
    
    var carsSearch: [Car] {
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
                    Text("Kendaraan Baru").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal).padding(.top)

                GroupedCarList(car: carsSearch).scrollContentBackground(.hidden).searchable(text: $searchText, placement: .navigationBarDrawer)

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
