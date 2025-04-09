//
//  FilterView.swift
//  CCL1-25GOAT
//
//  Created by Christian Luis Efendy on 26/03/25.
//

import SwiftUI

struct FilterView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isDateFilterActive: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("Mulai Tanggal", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                DatePicker("Akhir Tanggal", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                Button {
                    // Add new entry logic here.
                    isDateFilterActive = true
                    dismiss()
                } label: {
                    Text("Terapkan filter")
                        .font(.system(size: 19, weight: .bold, design: .default))
                        .foregroundStyle(.white)
                        .frame(width: 330, height: 36, alignment: .center)
                        .background(Color.blue)
                        .containerShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
                }
//                Toggle("Apply Date Filter", isOn: $isDateFilterActive)
//                    .padding(.top)
                
//                HStack {
//                    Button("Clear Filter") {
//                        isDateFilterActive = false
//                        // Reset dates to defaults if needed
//                        startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
//                        endDate = Date()
//                        dismiss()
//                    }
//                    .foregroundColor(.red)
//                    .padding()
//                    .background(Color.red.opacity(0.1))
//                    .cornerRadius(8)
//                    
//                    Spacer()
//                    
//                    Button("Apply") {
//                        // The toggle already updates isDateFilterActive
//                        dismiss()
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(8)
//                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Filter Tanggal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Hapus") {
                        isDateFilterActive = false
                        dismiss()
                    }
                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }

            }
        }
    }
}
