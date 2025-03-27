//
//  DeleteConfirmationView.swift
//  CCL1-25GOAT
//
//  Created by Christian Luis Efendy on 26/03/25.
//

import SwiftUI

struct DeleteConfirmationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Are you sure you want to delete this vehicle?")
                    .font(.headline)
                    .padding()

                

                // ✅ Save Button
                HStack {
                    Button("Delete") {
                        dismiss() // Close sheet
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .tint(.red)
                    Button {
                        // Save logic here (e.g., add the note to the vehicle, etc.)
                        dismiss()
                    }label: {
                    Text("Cancel")
                    }
//                        .buttonStyle(.borderedProminent)
                }
            }
//            .navigationTitle("Edit Plate")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DeleteConfirmationView()
}
