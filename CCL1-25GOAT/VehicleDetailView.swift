import SwiftUI

struct VehicleDetailView : View {
    
<<<<<<< Updated upstream
    let plate: String
    
    var body: some View {
            
        VStack {
            Text("Vehicle Detail View").font(.headline)
        }.background(.ultraThinMaterial)
            .navigationBarTitleDisplayMode(.inline) // gets rid of spacing below title
        // need to change to actual background color
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    
                } label: {
                    HStack {
                        Text(plate).font(.system(size: 20, weight: .bold, design: .default)).foregroundStyle(.white)
                        Image(systemName: "pencil")
=======
    let entry: Entries

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
                if let note = entry.note {
                    Text(note)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Text(entry.time.formatted(date: .omitted, time: .shortened))

        }
    }
}

struct VehicleDetailView: View {
    let vehicle: Cars
    @State private var searchText = ""
    @State private var showFilterSheet = false  // Show/hide the filter modal
    @State private var showEditSheet = false
    @State private var showAddNoteSheet = false
    @State private var showDeleteConfirmationSheet = false
    @State private var startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date() // Default: 7 days ago
    @State private var endDate = Date() // Default: Today
    @State private var plateNumber: String
    
    
    init(vehicle: Cars) {
            self.vehicle = vehicle
            // Initialize plateNumber from the passed vehicle
            _plateNumber = State(initialValue: vehicle.plate)
        }
    
    var filteredEntries: [String: [Entries]] {
            vehicle.groupedEntries
                .mapValues { $0.filter { entry in
                    entry.time >= startDate && entry.time <= endDate
                }}
                .filter { !$0.value.isEmpty }
        }
    var body: some View {
//        NavigationStack {
            
            List {
                ForEach(vehicle.groupedEntries.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                    Section(header: Text(date).font(.headline)) {
                        ForEach(vehicle.groupedEntries[date] ?? [], id: \.time) { entry in
                            
                            VehicleDetailCard(entry: entry)
                                .swipeActions(edge: .leading) {
                                    Button(role: .cancel) {
                                                print("Delete tapped")
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                            
                                    }
                                        }
                            
                                .swipeActions(edge: .trailing) {
                                    
                                            Button(role: .destructive) {
                                                print("Delete tapped")
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                    
                                
                                }
                                

                                                    
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
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
>>>>>>> Stashed changes
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                FilterView(startDate: $startDate, endDate: $endDate)
                    .presentationDetents([.fraction(0.4)])
            
<<<<<<< Updated upstream
            ToolbarItem(placement: .bottomBar) {
                Button {
                    
                } label: {
                    Text("+ Add New Note").font(.system(size: 19, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(width: 330, height: 36, alignment: .center)
                        .background(Color.blue)
                        .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                }
            }
        }.toolbarBackground(.visible, for: .navigationBar)
=======
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
>>>>>>> Stashed changes
    }
}

#Preview {
    DashboardView()
}
