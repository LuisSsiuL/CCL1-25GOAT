import SwiftUI
import SwiftData
import PhotosUI
import UIKit

struct AddNewEntryView: View {
    
    enum ForumFields: Int, Hashable {
        case plateNumber = 0
        case category
        case catetan
    }

    @Environment(\.modelContext) var modelContext
    @Query var cars: [Car]
    @State private var selectedCar: Car?

    // Improved image handling
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var showCameraSheet = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera

    @State private var plateNumber: String = ""
    @State private var selectedVehicleType: String = ""
    @State private var textEditorCatatan: String = ""
    @State private var textEditorCategory: String = ""
    @State private var showScannerSheet = false
    @FocusState private var focusedField: ForumFields?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    plateNumberSection
                    VehicleTypeChooser(selectedVehicleType: $selectedVehicleType)
                    
                    // Enhanced image section with camera support
                    imagePickerSection
                    
                    categorySection
                    catatanSection
                }
                .padding(.bottom, 30)
                .padding(.top, 16)
                .navigationTitle("Catatan Baru")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Batal") {
                            dismiss()
                        }.tint(.blue)
                    }

                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Simpan") {
                            saveEntry()
                            dismiss()
                        }
                        .disabled(plateNumber.isEmpty || selectedVehicleType == "" || textEditorCategory == "")
                        .bold()
                    }
                }
                .fullScreenCover(isPresented: $showScannerSheet) {
                    PlateScannerView(plateNumber: $plateNumber)
                }
                .fullScreenCover(isPresented: $showCameraSheet) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
                }
            }
            .onTapGesture {
                focusedField = nil
            }
        }
    }

    private var plateNumberSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text("Plat Nomor Kendaraan")
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                
                TextField("cth. B 1234 ABC", text: $plateNumber)
                    .focused($focusedField, equals: .plateNumber)
                    .onSubmit { focusedField = .category }
                    .padding()
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(5)
                    .autocapitalization(.allCharacters)
                    .padding(.horizontal, 16)
            }
            
            Button {
                showScannerSheet = true
            } label: {
                Image(systemName: "camera")
                    .font(.system(size: 18))
                    .frame(width: 20, height: 20)
                    .padding()
                    .foregroundColor(.blue)
                    .background(.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue)
                    }
            }
            .padding([.top, .bottom, .trailing], 16)
        }
    }
    
    // Enhanced image picker section with camera support
    private var imagePickerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Foto Kendaraan")
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
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
                        showCameraSheet = true
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

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Kategori")
                .fontWeight(.bold)

            ZStack(alignment: .leading) {
                if textEditorCategory.isEmpty {
                    Text("Kerusakan / Kehilangan / dll.")
                        .foregroundColor(Color(UIColor.systemGray3))
                        .padding(8)
                }

                TextField("", text: $textEditorCategory)
                    .focused($focusedField, equals: .category)
                    .onSubmit { focusedField = .catetan }
                    .padding(8)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            )
        }
        .padding(16)
    }

    private var catatanSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Catatan")
                .fontWeight(.bold)

            ZStack(alignment: .topLeading) {
                if textEditorCatatan.isEmpty {
                    Text("Contoh: Komponen Hilang, etc")
                        .foregroundColor(Color(UIColor.systemGray3))
                        .padding(12)
                        .font(.subheadline)
                }

                TextEditor(text: $textEditorCatatan)
                    .focused($focusedField, equals: .catetan)
                    .onSubmit { focusedField = nil }
                    .font(.subheadline)
                    .frame(height: 100)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    )
            }
        }
        .padding(16)
    }

    private func saveEntry() {
        let trimmedPlate = plateNumber.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Make sure we compress the image data to avoid excessive storage usage
        var imageDataToSave: Data? = nil
        if let image = selectedImage {
            imageDataToSave = image.jpegData(compressionQuality: 0.7)
        }
        
        if let existingCar = cars.first(where: { $0.plate.uppercased() == trimmedPlate }) {
            let newEntry = Entry(category: textEditorCategory,
                                 time: Date.now,
                                 note: textEditorCatatan)
            
            // Update the image property after initialization
            if let imageData = imageDataToSave {
                newEntry.image = imageData
            }
            
            existingCar.entry.append(newEntry)
            try? modelContext.save()
        } else {
            let newCar = Car(plate: trimmedPlate, type: selectedVehicleType)
            let newEntry = Entry(category: textEditorCategory,
                                 time: Date.now,
                                 note: textEditorCatatan)
            
            // Update the image property after initialization
            if let imageData = imageDataToSave {
                newEntry.image = imageData
            }
            
            newCar.entry.append(newEntry)
            modelContext.insert(newCar)
            try? modelContext.save()
        }
    }
}

// UIKit integration for camera access
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddNewEntryView()
}

struct VehicleTypeChooser: View {
    
    @Binding var selectedVehicleType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pilih Jenis Kendaraan")
                .fontWeight(.bold)
                .padding(.horizontal, 16)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 30) {
                    Image(systemName: "motorcycle.fill")
                        .font(.system(size: 30))
                    Text("Motor")
                }
                .frame(width: 150, height: 150)
                .foregroundColor(selectedVehicleType == "Bike" ? .white : Color(UIColor.systemGray3))
                .background(selectedVehicleType == "Bike" ? .blue : .clear)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
                .onTapGesture {
                    withAnimation {
                        selectedVehicleType = (selectedVehicleType == "Bike") ? "" : "Bike"
                    }
                }
                
                VStack(spacing: 30) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 30))
                    Text("Mobil")
                }
                .frame(width: 150, height: 150)
                .foregroundColor(selectedVehicleType == "Car" ? .white : Color(UIColor.systemGray3))
                .background(selectedVehicleType == "Car" ? .blue : .clear)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
                .onTapGesture {
                    withAnimation {
                        selectedVehicleType = (selectedVehicleType == "Car") ? "" : "Car"
                    }
                }
            }
            .padding(.horizontal, 25)
        }
        .padding(.vertical, 16)
    }
}
