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
            Text(date.formatted(.dateTime.day().month().year())).font(.headline)
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
    var latestEntry: Entry {
            cars.entry.sorted(by: { $0.time > $1.time }).first!
        }
    
    var body: some View {
        HStack {
            VStack{
                HStack{
                    Image(systemName: cars.type == "Car" ? "car.side.fill" : "motorcycle.fill").foregroundStyle(.secondary)
                        .font(.system(size: 24))
                    
                    Text(cars.plate)
                        .font(.title2)
                        .fontWeight(.bold)
                        
                    Spacer()
                 
                    
                }
                HStack {
                    Text(latestEntry.category)
                        .font(.footnote)
                    Text(latestEntry.note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                
                
                
                Divider()
                HStack{
                    Text("Note posted \(relativeTimeString(from: cars.mostRecentEntry))")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                    Spacer()
                }
                
            }
            
            Spacer()
        }
    }
    
    func relativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short // or use .full for "Last updated 2 hours ago"
        return formatter.localizedString(for: date, relativeTo: Date())
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
    @State private var isSearchBarVisible: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Kendaraan Baru").font(.largeTitle).fontWeight(.bold)
                    Spacer()
                }.padding(.horizontal).padding(.top)
                
                GroupedCarList(car: carsSearch).scrollContentBackground(.hidden)
            }
            .background(.ultraThinMaterial)
            .overlay {
                if isSearchBarVisible {
                    Color.black.opacity(0.0001) // Invisible but catchable overlay
                        .onTapGesture {
                            isSearchBarVisible = false
                            searchText = ""
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Welcome").font(.system(size: 20, weight: .bold, design: .default))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            isSearchBarVisible.toggle()
                            if !isSearchBarVisible {
                                searchText = ""
                            }
                        }
                    } label: {
                        Image(systemName: isSearchBarVisible ? "xmark" : "magnifyingglass")
                            .foregroundColor(.gray)
                            .font(.system(size: 20, design: .default))
                    }
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
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .modifier(SearchBarModifier(isSearchBarVisible: $isSearchBarVisible, searchText: $searchText))
        }
    }
}

// Create a custom search bar modifier
struct SearchBarModifier: ViewModifier {
    @Binding var isSearchBarVisible: Bool
    @Binding var searchText: String
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top) {
                if isSearchBarVisible {
                    VStack(spacing: 0) {
                        Divider()
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search", text: $searchText)
                                .submitLabel(.search)
                                .onSubmit {
                                    // Handle search submission if needed
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        Divider()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
    }
}

#Preview {
    DashboardView()
}
