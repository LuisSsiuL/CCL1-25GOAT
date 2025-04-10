import SwiftUI
import SwiftData

struct AddNewEntryView: View {
    
    enum ForumFields: Int, Hashable {
        case plateNumber = 0
        case category
        case catetan
    }

    @Environment(\.modelContext) var modelContext
    @Query var cars: [Car]
    @State private var selectedCar: Car?

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
                        .disabled(plateNumber.isEmpty || selectedVehicleType == "")
                        .bold()
                    }
                }
                .fullScreenCover(isPresented: $showScannerSheet) {
                    PlateScannerView(plateNumber: $plateNumber)
                        
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
                Form {
                    Text("Plat Nomor Kendaraan")
                        .fontWeight(.bold)
                    TextField("cth. B 1234 ABC", text: $plateNumber)
                        .focused($focusedField, equals: .plateNumber)
                        .onSubmit { focusedField = .category }
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(5)
                        .autocapitalization(.allCharacters)
                }
            }
            .formStyle(.columns)
            .padding(.leading, 16)
            .padding(.vertical, 16)

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

        if let existingCar = cars.first(where: { $0.plate.uppercased() == trimmedPlate }) {
            let newEntry = Entry(category: existingCar.type, time: Date.now, note: textEditorCatatan)
            existingCar.entry.append(newEntry)
            try? modelContext.save()
        } else {
            let newCar = Car(plate: trimmedPlate, type: selectedVehicleType)
            let newEntry = Entry(category: textEditorCategory, time: Date.now, note: textEditorCatatan)
            newCar.entry.append(newEntry)
            modelContext.insert(newCar)
            try? modelContext.save()
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
                .multilineTextAlignment(.leading)
            
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
                        print(selectedVehicleType)
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
                        print(selectedVehicleType)
                    }
                }
            }
            .padding(.horizontal, 25)
        }
        .padding(16)
    }
}
