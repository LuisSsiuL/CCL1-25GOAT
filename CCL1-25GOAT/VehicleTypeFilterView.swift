import SwiftUI

struct VehicleTypeFilterView: View {
    
    @Binding var filterVehicleType: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Filter By Vehicle Type")
                Spacer()
            }.padding([.horizontal])
            
            Picker(selection: $filterVehicleType, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                Text("Semua Tipe").tag("")
                Image(systemName: "car.side.fill").tag("Car")
                Image(systemName: "motorcycle.fill").tag("Bike")
            }
            .padding()
            .frame(height: 50)
            
            Button {
                dismiss()
            } label: {
                Text("Done")
                    .font(.system(size: 19, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                    .frame(width: 330, height: 36, alignment: .center)
                    .background(Color.blue)
                    .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    DashboardView()
}
