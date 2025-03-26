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
            } else {
                
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

struct VehicleDetailView: View {
    
    let vehicle: [Car]
    @State private var searchText = ""
    
    var body: some View {

        List {
            ForEach(vehicle.groupedEntries.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                Section(header: Text(date).font(.headline)) {
                    ForEach(vehicle.groupedEntries[date] ?? [], id: \.time) { entry in
                        
                        VehicleDetailCard(entry: entry)
                            .swipeActions {
                                DeleteButton(for: entry)
                                EditButton(for: entry)
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
                                
                            } label: {
                                HStack {
                                    Text(vehicle.plate).font(.system(size: 20, weight: .bold, design: .default)).foregroundStyle(.black)
                                    Image(systemName: "pencil")
                                }
                            }
                        }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                }
                label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.yellow)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button {
                    // Add delete logic
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button {
                    // Add new note logic
                } label: {
                    Text("+ Add New Note").font(.system(size: 19, weight: .bold, design: .default))
                                            .foregroundStyle(.white)
                                            .frame(width: 330, height: 36, alignment: .center)
                                            .background(Color.blue)
                                            .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                }
            }
        }
    }
}

#Preview {
    
    DashboardView()
    
}
