//
//  ContentView.swift
//  CCL1-25GOAT
//
//  Created by Christian Luis Efendy on 24/03/25.
// Test

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
            
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0){
                    CustomSearchBar(text: $searchText)
                   
                    HStack{
                        
                        Text("20 Maret 2025")
                            .font(.title)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                        Spacer()
                        
                    }
                    Spacer()
                
                }
                .navigationTitle("Welcome!")
                
                if !searchText.isEmpty && !filteredVehicles.isEmpty {
                    VStack(alignment: .leading){
                        ForEach(filteredVehicles, id:\.self) {
                            plat in Button(
                                action: {
                                //Action later prob direct to vehicle information page
                                    searchText = plat
                            })
                                {
                                Text(plat)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                }
                            Divider()
                        }
                        Spacer()
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal, 10)
                    // Adjust the offset to position the drop-down just below the search bar.
                        .offset(y: 45)
                }
            }
           
                
            }
        
        }
    }

#Preview {
    ContentView()
}
