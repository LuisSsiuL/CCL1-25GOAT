import SwiftUI

struct VehicleDetailCard: View {
    
    let entry: Entry

    var body: some View {
        VStack {
            
            HStack {
                if let imageData = entry.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(entry.category)
                        .font(.subheadline)
                        .bold()
                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Text(entry.time.formatted(date: .omitted, time: .shortened))
                
            }
        }
    }
}

private func DeleteButton(for entry: Entry) -> some View {
    Button(role: .destructive) {
        print("Delete tapped")
    } label: {
        Label("Delete", systemImage: "trash")
    }
}

private func EditButton(for entry: Entry) -> some View {
    Button(role: .cancel) {
        print("Edit tapped")
    } label: {
        Label("Edit", systemImage: "pencil")
    }
}

struct GroupedEntryView: View {
    
    let entry: [Entry]
    var headerView: AnyView? = nil
    
    private var groupedEntries: [Date: [Entry]] {
        Dictionary(grouping: entry) { entry in
            Calendar.current.startOfDay(for: entry.time)
        }
    }
    
    private var sectionDates: [Date] {
        groupedEntries.keys.sorted(by: >)
    }
    
    private func entrySectionHeader(for date: Date) -> some View {
        HStack {
            Text(date, style: .date)
            Spacer()
        }
    }
    
    private func entrySection(date: Date, groupedEntry: [Date: [Entry]]) -> some View {
        guard let entry = groupedEntry[date], !entry.isEmpty else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            Section(header: entrySectionHeader(for: date)) {
                ForEach(entry, id: \.self) { entry in
                    NavigationLink {
                        
                    } label: {
                        VehicleDetailCard(entry: entry)
                            .swipeActions(edge: .leading) {
                                EditButton(for: entry)
                            }
                            .swipeActions(edge: .trailing) {
                                DeleteButton(for: entry)
                            }
                    }
                }
            }
        )
    }
    
    var body: some View {
        List {
            if let headerView = headerView {
                Section {
                    headerView
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            
            ForEach(sectionDates, id: \.self) { date in
                entrySection(date: date, groupedEntry: groupedEntries)
            }
        }
        .listStyle(GroupedListStyle())
    }
}

struct CategoryVehicleDetailView: View {
    @Binding var selectedVehicle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Image(systemName: "motorcycle.fill").font(.system(size: 20))
                Text("Motor")
            }
            .frame(width: 75, height: 75)
            .foregroundColor(selectedVehicle == "Bike" ? .white: .grey2)
            .background(selectedVehicle == "Bike" ? .blue : .clear)
            .cornerRadius(15)
            .overlay{RoundedRectangle(cornerRadius: 15).stroke(Color.grey1,lineWidth: 2)}
            .onTapGesture {
                withAnimation {
                    selectedVehicle = "Bike"
                }
            }
            
            VStack(spacing: 5) {
                Image(systemName: "car.fill").font(.system(size: 20))
                Text("Mobil")
            }
            .frame(width: 75, height: 75)
            .foregroundColor(selectedVehicle == "Car" ? .white: .grey2)
            .background(selectedVehicle == "Car" ? .blue : .clear)
            .cornerRadius(15)
            .overlay{RoundedRectangle(cornerRadius: 15).stroke(Color.grey1,lineWidth: 2)}
            .onTapGesture {
                withAnimation {
                    selectedVehicle = "Car"
                }
            }
        }
    }
}

struct VehicleDetailView: View {
    
    let vehicle: Car
    @State private var searchText = ""
    @State private var showFilterSheet = false
    @State private var showEditSheet = false
    @State private var showAddNoteSheet = false
    @State private var showDeleteAlert = false
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    @State private var endDate = Date()
    @State private var plateNumber: String
    @State private var entryToDelete: Entry? = nil
    @State private var selectedVehicle: String
    @State private var isDateFilterActive = false // Track if date filter has been applied
    
    init(vehicle: Car) {
        self.vehicle = vehicle
        // Initialize plateNumber from the passed vehicle
        _plateNumber = State(initialValue: vehicle.plate)
        _selectedVehicle = State(initialValue: vehicle.type)
    }
    
    // First filter entries by date range (only if date filter is active)
    private var dateFilteredEntries: [Entry] {
        if isDateFilterActive {
            return vehicle.entry.filter { entry in
                entry.time >= startDate && entry.time <= endDate
            }
        } else {
            return vehicle.entry // Return all entries if filter is not active
        }
    }
    
    // Then filter date-filtered entries by search text
    private var filteredEntries: [Entry] {
        if searchText.isEmpty {
            return dateFilteredEntries
        } else {
            return dateFilteredEntries.filter { entry in
                entry.category.localizedCaseInsensitiveContains(searchText) ||
                entry.note.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        let headerView = AnyView(
            VStack(spacing: 0) {
                HStack {
                    TextField("Plate Number", text: .constant(vehicle.plate), prompt: Text("Write your plate number"))
                        .multilineTextAlignment(.center)
                        .padding(.all, 5)
                        .frame(height: 75)
                        .background(.white)
                        .cornerRadius(5)
                        .font(.largeTitle)
                    
                    CategoryVehicleDetailView(selectedVehicle: $selectedVehicle)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
            }
        )
        
        GroupedEntryView(entry: filteredEntries, headerView: headerView)
            .padding(.top)
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Search categories")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(isDateFilterActive ? .blue.opacity(0.7) : .blue)
                            .overlay {
                                // Show indicator dot if filter is active
                                if isDateFilterActive {
                                    Circle()
                                        .fill(.blue)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 8, y: -8)
                                }
                            }
                    }
                    
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        // Add new note logic
                        showAddNoteSheet = true
                    } label: {
                        Text("+ Add New Note").font(.system(size: 19, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .frame(width: 330, height: 36, alignment: .center)
                            .background(Color.blue)
                            .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(
                    startDate: $startDate,
                    endDate: $endDate,
                    isDateFilterActive: $isDateFilterActive
                )
                .presentationDetents([.fraction(0.4)])
                
            }
            .sheet(isPresented: $showEditSheet) {
                VehicleEditView(plateNumber: $plateNumber)
                    .presentationDetents([.fraction(0.4)])
            }
            .sheet(isPresented: $showAddNoteSheet) {
                VehicleAddNoteView()
            }
            .alert("Confirm Deletion?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    // Delete logic would go here
                }
            } message: {
                Text("Are you sure you want to delete this vehicle?")
            }
    }
}
#Preview {
    DashboardView()
}
