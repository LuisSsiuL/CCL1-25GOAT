import SwiftUI

struct VehicleDetailView : View {
    
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
                    }
                }
            }
            
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
