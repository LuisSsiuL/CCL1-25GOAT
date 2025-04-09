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
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                
                Toggle("Apply Date Filter", isOn: $isDateFilterActive)
                    .padding(.top)
                
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
            .navigationTitle("Date Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

            }
        }
    }
}
