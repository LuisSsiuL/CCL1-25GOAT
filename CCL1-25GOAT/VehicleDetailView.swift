import SwiftUI

struct VehicleDetailCard: View {
    
    let entry: Entry

    var body: some View {
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
private func DeleteButton(for entry: Entry) -> some View {
    Button(role: .destructive) {
        print("Delete tapped")
    } label: {
        Label("Delete", systemImage: "trash")
    }
}

private func EditButton(for entry: Entry) -> some View {
    Button(role: .cancel) {
        print("Delete tapped")
    } label: {
        Label("Edit", systemImage: "pencil")
    }
}

struct GroupedEntryView: View {
    
    let entry: [Entry]
    
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
                                EditButton()
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
            ForEach(sectionDates, id: \.self) { date in
                entrySection(date: date, groupedEntry: groupedEntries)
            }
        }.listStyle(GroupedListStyle())
    }
    
}

struct VehicleDetailView: View {
    let vehicle: Car
    @State private var searchText = ""
    @State private var showFilterSheet = false  // Show/hide the filter modal
    @State private var showEditSheet = false
    @State private var showAddNoteSheet = false
    @State private var showDeleteConfirmationSheet = false
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date() // Default: 7 days ago
    @State private var endDate = Date() // Default: Today
    @State private var plateNumber: String
    
    
    init(vehicle: Car) {
            self.vehicle = vehicle
            // Initialize plateNumber from the passed vehicle
            _plateNumber = State(initialValue: vehicle.plate)
        }
    
    var filteredEntries: [Date: [Entry]] {
        vehicle.groupedEntries
            .mapValues { $0.filter { entry in
                entry.time >= startDate && entry.time <= endDate
            }}
            .filter { !$0.value.isEmpty }
    }

    var body: some View {
            
            GroupedEntryView(entry: vehicle.entry)
//            List {
//                ForEach(vehicle.groupedEntries.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
//                    Section(header: Text(date).font(.headline)) {
//                        ForEach(vehicle.groupedEntries[date] ?? [], id: \.time) { entry in
//                            
//                            VehicleDetailCard(entry: entry)
//                                .swipeActions(edge: .leading) {
//                                    Button(role: .cancel) {
//                                                print("Delete tapped")
//                                    } label: {
//                                        Label("Edit", systemImage: "pencil")
//                                            
//                                    }
//                                        }
//                            
//                                .swipeActions(edge: .trailing) {
//                                    
//                                            Button(role: .destructive) {
//                                                print("Delete tapped")
//                                            } label: {
//                                                Label("Delete", systemImage: "trash")
//                                            }
//                                    
//                                
//                                }
//                                
//
//                                                    
//                            .padding(.vertical, 4)
//                        }
//                    }
//                }
//            }
            .searchable(text: $searchText, prompt: "Search categories" )
            .padding(.top)
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                                Button {
                                    showEditSheet = true
                                } label: {
                                    HStack {
                                        Image(systemName: vehicle.type == "Car" ? "car.side.fill" : "motorcycle.fill").foregroundStyle(.secondary)
                                            .foregroundColor(.gray)
                                        Text(vehicle.plate).font(.system(size: 20, weight: .bold, design: .default)).foregroundStyle(.black)
                                        Image(systemName: "pencil")
                                    }
                                }
                            }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showFilterSheet = true
                    }
                    label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.yellow)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        // Add delete logic
                        showDeleteConfirmationSheet = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
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
                FilterView(startDate: $startDate, endDate: $endDate)
                    .presentationDetents([.fraction(0.4)])
            
        }
            .sheet(isPresented: $showEditSheet) {
                VehicleEditView(plateNumber: $plateNumber)
                    .presentationDetents([.fraction(0.4)])
                
            }
            .sheet(isPresented: $showAddNoteSheet) {
                VehicleAddNoteView()
            }
            .sheet(isPresented: $showDeleteConfirmationSheet) {
                DeleteConfirmationView()
                    .presentationDetents([.fraction(0.2)])
            }
    }
}

#Preview {
    
    DashboardView()
    
}
