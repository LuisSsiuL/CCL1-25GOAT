import SwiftUI

struct VehicleDetailCard: View {
    let entry: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(entry.category)
                        .font(.headline)
                        .bold()
                    if !entry.note.isEmpty {
                        Text(entry.note)
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Text(entry.time.formatted(date: .omitted, time: .shortened))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Display image if available
            if let imageData = entry.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .clipped()
            }
        }
        .padding(.vertical, 8)
    }
}

struct GroupedEntryView: View {
    @Environment(\.modelContext) var modelContext
    
    let entry: [Entry]
    let vehicle: Car
    var headerView: AnyView? = nil
    @Binding var isLastEntry: Bool
    
    private var groupedEntries: [Date: [Entry]] {
        Dictionary(grouping: entry, by: { Calendar.current.startOfDay(for: $0.time) })
            .mapValues { $0.sorted(by: { $0.time > $1.time }) }
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
                    VehicleDetailCard(entry: entry)
//                            .swipeActions(edge: .leading) {
//                                EditButton(for: entry)
//                            }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            DeleteButton(for: entry)
                        }
                }
            }
        )
    }
    
    private func DeleteButton(for entry: Entry) -> some View {
        Button(role: .destructive) {
            if (vehicle.entry.count == 1 && vehicle.entry.first === entry) {
                isLastEntry = true
            } else { deleteEntry(entry: entry) }
            print("Delete tapped")
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private func deleteEntry(entry: Entry) {
        modelContext.delete(entry)
        try? modelContext.save()
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
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    var vehicle: Car
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
    @State private var isDataChanged: Bool = false
    @State private var isDeleted: Bool = false
    @State var isLastEntry: Bool = false
    
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
                    TextField("Plate Number", text: $plateNumber, prompt: Text("Masukkan plat nomor kendaraan"))
                        .multilineTextAlignment(.center)
                        .padding(.all, 5)
                        .frame(height: 75)
                        .background(.white)
                        .cornerRadius(5)
                        .font(.largeTitle)
                        .onChange(of: plateNumber) {
                            isDataChanged = true
                        }
                    
                    CategoryVehicleDetailView(selectedVehicle: $selectedVehicle).onChange(of: selectedVehicle) {
                        isDataChanged = true
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                
                Button {
                    saveVehicle(vehicle: vehicle)
                    isDataChanged = false
                } label: {
                    Text("Simpan Perubahan")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(width: 300, height: isDataChanged ? 36 : 0, alignment: .center)
                        .background(Color.blue)
                        .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                        .opacity(isDataChanged ? 1 : 0)
                }
                .disabled(!isDataChanged)
                .frame(height: isDataChanged ? 36 : 0)
                .padding(isDataChanged ? 10 : 0)
            }
        )
        
        GroupedEntryView(entry: filteredEntries, vehicle: vehicle, headerView: headerView, isLastEntry: $isLastEntry)
            .padding(.top)
            .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Cari catatan")
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
                        Text("+ Tambahkan Catatan Baru").font(.system(size: 19, weight: .bold, design: .default))
                            .foregroundStyle(.white)
                            .frame(width: 330, height: 44, alignment: .center)
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
                VehicleAddNoteView(selectedVehicle: vehicle)
                    .presentationDetents([.fraction(0.8)])
            }
            .alert("Hapus Kendaraan?", isPresented: $showDeleteAlert) {
                Button("Hapus", role: .destructive) {
                    // Delete logic would go here
                    deleteVehicle(vehicle: vehicle)
                    isDeleted = true
                    dismiss()
                }
                Button("Batal", role: .cancel) {}
            } message: {
                Text("Apakah anda yakin ingin menghapus data kendaraan ini?")
            }
            .alert(isPresented: $isLastEntry) {
                Alert(title: Text("Hapus Catatan"), message: Text("Catatan ini adalah satu-satunya data untuk kendaraan ini. Menghapusnya berarti seluruh informasi kendaraan akan ikut terhapus. Tetap lanjutkan?"), primaryButton: .cancel(Text("Batal")), secondaryButton: .destructive(Text("Lanjut"), action: {
                    
                    deleteVehicle(vehicle: vehicle)
                    dismiss()
                    
                }))
            }
    }
    
    func deleteVehicle(vehicle: Car) {
        modelContext.delete(vehicle)
        try? modelContext.save()
    }
    
    private func saveVehicle(vehicle: Car) {
        vehicle.plate = plateNumber
        vehicle.type = selectedVehicle
        try? modelContext.save()
    }
    
}

#Preview {
    DashboardView()
}
