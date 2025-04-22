import SwiftUI
import PhotosUI
import UIKit

struct VehicleAddNoteView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    var selectedVehicle: Car

    @State private var textEditorCategory: String = ""
    @State private var textEditorNote: String = ""
    
    // Image handling properties
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case category
        case note
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Added Image Section
                    imagePickerSection
                    
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
            }
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
            .sheet(isPresented: $showImagePicker) {
                if sourceType == .camera {
                    // Use UIKit image picker for camera
                    UIImagePickerControllerRepresentation(
                        sourceType: sourceType,
                        onImagePicked: { image in
                            selectedImage = image
                        }
                    )
                } else {
                    // For photo library, we'll use PhotosPicker instead
                    // This is just a fallback
                    Text("Please use the gallery button")
                        .padding()
                }
            }
        }
    }
    
    // Image picker section
    private var imagePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Foto Kendaraan")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 12) {
                // Preview of selected image
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                    
                    // Option to remove image
                    Button(action: {
                        withAnimation {
                            selectedImage = nil
                            photoData = nil
                            selectedPhotoItem = nil
                        }
                    }) {
                        Label("Hapus Foto", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.bottom, 8)
                } else {
                    // Placeholder when no image is selected
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.systemGray6))
                            .frame(height: 120)
                        
                        VStack(spacing: 8) {
                            Image(systemName: "photo")
                                .font(.system(size: 32))
                                .foregroundColor(.gray)
                            Text("Tambahkan Foto Kendaraan")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                // Two buttons side by side: Camera and Gallery
                HStack(spacing: 12) {
                    // Camera button
                    Button {
                        sourceType = .camera
                        showImagePicker = true
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Ambil Foto")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // Gallery button
                    PhotosPicker(selection: $selectedPhotoItem,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                            Text("Galeri")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .onChange(of: selectedPhotoItem) {
                        if let item = selectedPhotoItem {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    photoData = data
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
    }

    private func saveEntry() {
        let newEntry = Entry(category: textEditorCategory, time: Date.now, note: textEditorNote)
        
        // Add image data to the entry if available
        if let image = selectedImage {
            // Compress the image to reduce storage size
            let imageDataToSave = image.jpegData(compressionQuality: 0.7)
            newEntry.image = imageDataToSave
        }
        
        selectedVehicle.entry.append(newEntry)
        try? modelContext.save()
        print("Entry added to car \(selectedVehicle.plate)")
    }
}

// A simpler UIImagePickerController wrapper without using Coordinator
struct UIImagePickerControllerRepresentation: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: UIImagePickerControllerRepresentation
        
        init(_ parent: UIImagePickerControllerRepresentation) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
