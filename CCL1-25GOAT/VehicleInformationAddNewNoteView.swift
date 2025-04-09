import SwiftUI

struct VehicleAddNoteView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    var selectedVehicle: Car

    @State private var textEditorCategory: String = ""
    @State private var textEditorNote: String = ""

    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case category
        case note
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Category Field
                HStack {
                    Text("Kategori:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)

                TextField("Kerusakan / Kehilangan / dll.", text: $textEditorCategory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .focused($focusedField, equals: .category)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .note
                    }

                // Note Field with TextEditor
                HStack {
                    Text("Catatan:")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)

                TextEditor(text: $textEditorNote)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .focused($focusedField, equals: .note)

                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Catatan Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Simpan") {
                        saveEntry()
                        dismiss()
                    }
                    .bold()
                    .disabled(textEditorCategory.isEmpty && textEditorNote.isEmpty)
                }
            }
            .onTapGesture {
                focusedField = nil // dismiss keyboard
            }
        }
        
    }

    private func saveEntry() {
        let newEntry = Entry(category: textEditorCategory, time: Date.now, note: textEditorNote)
        selectedVehicle.entry.append(newEntry)
        try? modelContext.save()
        print("Entry added to car \(selectedVehicle.plate)")
    }
}
