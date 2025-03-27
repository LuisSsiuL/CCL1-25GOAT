import SwiftUI

struct VehicleDetailView : View {
    
    let plate: String
    
    var body: some View {
<<<<<<< Updated upstream
            
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
                    }
                }
            }
=======
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
                if entry.note.isEmpty == false {
                    Text(entry.note)
                        .font(.body)
                        .foregroundColor(.gray)
                } else {
                    Text("-")
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
    
    var body: some View {

        GroupedEntryView(entry: vehicle.entry)
        .searchable(text: $searchText, prompt: "Search categories")
        .toolbar {
            ToolbarItem(placement: .principal) {
                            Button {
                                
                            } label: {
                                HStack {
                                    Text(vehicle.plate).font(.system(size: 20, weight: .bold, design: .default)).foregroundStyle(.black)
                                    Image(systemName: "pencil")
                                }
                            }
                        }
>>>>>>> Stashed changes
            
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
    }
}

#Preview {
    DashboardView()
}
