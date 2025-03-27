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
    @Environment(\.dismiss) var dismiss // Dismiss the view when done

    var body: some View {
        VStack {
            Text("Select Date Range")
                .font(.headline)
                .padding()

            // 📅 Date Pickers
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()

            DatePicker("End Date", selection: $endDate, in: startDate...Date(), displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()

            Spacer()

            // ✅ Apply Filter Button
            Button("Apply Filter") {
                dismiss()  // Close the view and return to VehicleDetailView
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Filter Entries")
        .navigationBarTitleDisplayMode(.inline)
    }
}

