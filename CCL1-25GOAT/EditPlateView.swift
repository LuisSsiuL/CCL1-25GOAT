import SwiftUI

struct VehicleEditView: View {
    @Binding var plateNumber: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter new plate number", text: $plateNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Spacer()
            }
            .navigationTitle("Edit Plate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel button on the top left
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.blue)
                }
                
                // Save button on the top right
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // Save logic here
                        dismiss()
                    }
                    .bold(true)
//                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
