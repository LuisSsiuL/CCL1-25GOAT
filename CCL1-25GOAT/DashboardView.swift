import SwiftUI

struct Cars {
    var plate: String,
        type: String,
        time: Date
}

struct DashboardCard: View {
    let cars: Cars
    var body: some View {
        HStack {
            Image(systemName: cars.type == "Car" ? "car.side.fill" : "motorcycle.fill").foregroundStyle(.secondary)
            Text(cars.plate)
            Spacer()
            Text("12:30").foregroundStyle(.secondary)
//            Image(systemName: "chevron.right")
        }
//        .padding().background(Color.gray.opacity(0.1))
    }
}

struct DashboardView: View {
    
    @State private var cars = [
        Cars(plate: "ABC123", type: "Car", time: Date().addingTimeInterval(-3600)),
        Cars(plate: "XYZ789", type: "Bike", time: Date().addingTimeInterval(-1800)),
        Cars(plate: "DEF456", type: "Car", time: Date().addingTimeInterval(-900)),
        Cars(plate: "DEF456", type: "Car", time: Date().addingTimeInterval(-900)),
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
                        DashboardCard(cars: car)
                    }
                }.scrollContentBackground(.hidden)
                    .searchable(text: $searchText, placement: .navigationBarDrawer)
                
            }.background(.ultraThinMaterial)
                .navigationBarTitleDisplayMode(.inline) // gets rid of spacing below title
            // need to change to actual background color
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
