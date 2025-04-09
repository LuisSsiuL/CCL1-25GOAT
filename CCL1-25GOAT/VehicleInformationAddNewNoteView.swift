import SwiftUI

struct VehicleAddNoteView: View {
    @Environment(\.dismiss) var dismiss  // Dismiss the sheet when done
    @Environment(\.modelContext) var modelContext
    
    var selectedVehicle: Car
    
    @State private var textEditorCategory: String = ""
    @State private var textEditorNote: String = ""
    // Optionally, you can add a state for the photo:
    // @State private var selectedImage: UIImage? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Big button with a "+" icon for adding a photo
                Button(action: {
                    // Implement photo picker logic here if needed
                }) {
                    VStack {
                        Image(systemName: "plus")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        Text("Add Photo")
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // Category Field
                HStack {
                    Text("Category:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextField("Enter category", text: $textEditorCategory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Note Field with TextEditor for a larger area
                HStack {
                    Text("Note:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                
                TextEditor(text: $textEditorNote)
                    .frame(height: 150) // Adjust height as needed
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                // Bottom Save Button
                    .toolbar {
                        // Cancel button on the top left
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                dismiss()
                            }
//                            .tint(.red)
                        }
                        
                        // Save button on the top right
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                // Save logic here
                                
                                saveEntry()
                                
                                dismiss()
                            }
                            .bold(true)
        //                    .buttonStyle(.borderedProminent)
                        }
                    }
            }
            .padding(.vertical)
            .navigationTitle("Add New Note")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveEntry() {

        let newEntry = Entry(category: textEditorCategory, time: Date.now, note: textEditorNote)
        selectedVehicle.entry.append(newEntry)
        try? modelContext.save()
        print("Entry added to car \(selectedVehicle.plate)")
        
    }
    
}

#Preview {
    DashboardView()
}
