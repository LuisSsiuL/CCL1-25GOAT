import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Cari Nomor Plat..", text: $text)
                .padding(8)
            
            Button {
             
            } label: {
                Image(systemName: "camera.viewfinder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .foregroundColor(.blue)

            }
            .padding(.trailing, 8)
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal, 10)
    }
}

struct CustomSearchBarWrapper: View {
    @State private var text = ""
    
    var body: some View {
        CustomSearchBar(text: $text)
    }
}

#Preview {
    CustomSearchBarWrapper()
}
