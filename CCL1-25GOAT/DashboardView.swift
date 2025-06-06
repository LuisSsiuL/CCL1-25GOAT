import SwiftUI
import SwiftData

// MARK: - GroupedCarList

struct GroupedCarList: View {
    
    let car: [Car]
    
    private var groupedCar: [Date: [Car]] {
        Dictionary(grouping: car, by: { Calendar.current.startOfDay(for: $0.mostRecentEntry) })
            .mapValues { $0.sorted(by: { $0.mostRecentEntry > $1.mostRecentEntry }) }
    }

    
    private var sectionDates: [Date] {
        groupedCar.keys.sorted(by: >) // sorts by newest first
    }
    
    var body: some View {
        List {
            ForEach(sectionDates, id: \.self) { date in
                carSection(date: date, groupedCar: self.groupedCar)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func carSectionHeader(for date: Date) -> some View {
        HStack {
            Text(date.formatted(.dateTime.day().month().year()))
                .font(.headline)
            Spacer()
        }
    }
    
    private func carSection(date: Date, groupedCar: [Date: [Car]]) -> some View {
        guard let cars = groupedCar[date], !cars.isEmpty else {
            return AnyView(EmptyView())
        }
        return AnyView(
            
            Section(header: carSectionHeader(for: date)) {
                ForEach(cars) { car in
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

// MARK: - DashboardCard

struct DashboardCard: View {
    let cars: Car
    let entry: [Entry]
    
    var latestEntry: Entry {
        cars.entry.sorted(by: { $0.time > $1.time }).first!
    }
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: cars.type == "Car" ? "car.side.fill" : "motorcycle.fill")
                        .foregroundStyle(.secondary)
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
                        .frame(width: 100, alignment: .leading)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Spacer()
                }
                HStack {
                    Text(relativeTimeString(from: cars.mostRecentEntry))
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
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}


// MARK: - DashboardView

struct DashboardView: View {
    
    @State var filterVehicleType: String = ""
    
    @Query var cars: [Car]
    
    var carsFilter: [Car] {
        return cars.filter {
            $0.type == filterVehicleType || filterVehicleType.isEmpty
        }
    }
    
    var carsSearch: [Car] {
        return carsFilter.filter {
            $0.plate.lowercased().contains(searchText.lowercased())
        }
    }
  
    
    @State var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var showNewEntrySheet: Bool = false
    @State private var showScannerSheet: Bool = false
    @State private var showFilterSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Conditional content – if search is active, show search view; otherwise, show main content.
                if isSearching {
                    
                    VStack {
                        Button {
                            showScannerSheet = true
                        } label: {
                            Text("Pindai Plat Nomor")
                                .font(.system(size: 19, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                                .frame(width: 360, height: 44, alignment: .center)
                                .background(Color.blue)
                                .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        }
                        .padding(.all)
                        
                        GroupedCarList(car: carsSearch)
                            .scrollContentBackground(.hidden)
                    }
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: isSearching)
                } else {
                    VehicleTypeFilterView(filterVehicleType: $filterVehicleType)
                    GroupedCarList(car: carsFilter)
                        .scrollContentBackground(.hidden)
                    Button {
                        // Add new entry logic here.
                        showNewEntrySheet = true
                    } label: {
                        Text("+ Tambah Catatan Baru")
                            .font(.system(size: 19, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .frame(width: 330, height: 44, alignment: .center)
                            .background(Color.blue)
                            .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                    }
                    Spacer()
                }
            }
            .toolbar {
                // Principal title remains unchanged.
                ToolbarItem(placement: .principal) {
                    Text("Dashboard")
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundStyle(.black)
                }

            }
            .background(.ultraThinMaterial)
            .navigationBarTitleDisplayMode(.inline)
            // Use the default searchable modifier with the isPresented binding.
            .searchable(text: $searchText, isPresented: $isSearching, placement: .navigationBarDrawer, prompt: "Cari berdasarkan plat kendaraan...")
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showNewEntrySheet){
            AddNewEntryView()
                .presentationDetents([.fraction(0.95)])
        }
        .fullScreenCover(isPresented: $showScannerSheet){
            PlateScannerView(plateNumber: $searchText)
               
        }
    }
}

#Preview {
    DashboardView()
}
