//
//  ContentView.swift
//  CCL1-25GOAT
//
//  Created by Christian Luis Efendy on 24/03/25.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    let platNumbers = ["B 1234 A", "B 2345 B", "B 3456 C", "B 4567 D"]
    var filteredVehicles: [String] {
        if searchText.isEmpty{
            return []
        }
        else {
            return platNumbers.filter { $0.lowercased().contains(searchText.lowercased())}
        }
    }
    var body: some View {
        
        NavigationStack{
            
            VStack{
                CustomSearchBar(text: $searchText)
                HStack{
                    
                    Text("20 Maret 2025")
                        .font(.title)
                    Spacer()
                    
                }
                List(filteredVehicles, id: \.self) { platNumbers in
                    Text(platNumbers)
                    }
                
                
            }
            
            .navigationTitle("Welcome!")
           
                
            }
        
        }
    }
//<<<<<<< HEAD
//=======
//
//#Preview {
//    ContentView()
//>>>>>>> 0b8c0968aee3fcdfec938602d969c86b42659491
//}
