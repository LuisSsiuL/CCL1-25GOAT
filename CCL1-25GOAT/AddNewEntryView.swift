import SwiftUI
import SwiftData

struct AddNewEntryView: View {
    
    @State var plateNumber: String = ""
    @Environment(\.dismiss) var dismiss
    @State var selectedVehicleType: String? = nil
    @State private var textEditorCatatan: String = ""
    @State private var textEditorCategory: String = ""  // New state for category text field
    @State private var showNewEntrySheet = false
    @State private var showScannerSheet = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Section: Plate Number Form & Camera Button
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Form {
                            Text("Plat Nomor Kendaraan")
                                .fontWeight(.bold)
                            
                            TextField("Plate Number", text: $plateNumber, prompt: Text("Write your plate number"))
                                .padding()
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(5)
                        }
                    }
                    .formStyle(.columns)
                    .padding(.leading, 16)
                    .padding(.vertical, 16)
                    
                    Button {
                        showScannerSheet = true
                        print("loading camera")
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
                
                // Middle Section: Choose Vehicle (Motor / Mobil)
                VehicleTypeChooser(selectedVehicleType: selectedVehicleType)
                
                // New Section: Tambahkan Category
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tambahkan Category")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    ZStack(alignment: .leading) {
                        TextField("", text: $textEditorCategory)
                            .padding(8)
                        if textEditorCategory.isEmpty {
                            Text("Tulis category disini")
                                .foregroundColor(Color(UIColor.systemGray3))
                                .padding(8)
                        }
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                    }
                }
                .padding(16)
                
                // Bottom Section: Tambahkan Catatan
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tambahkan Catatan")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $textEditorCatatan)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                            }
                            .font(.subheadline)
                        if textEditorCatatan.isEmpty {
                            Text("Tulis catatan disini")
                                .foregroundColor(Color(UIColor.systemGray3))
                                .font(.subheadline)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                        }
                    }
                }
                .padding(16)
            
                Spacer() // Ensures content is pushed to the top.
            }
            .navigationTitle("Entry Baru")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel Button (Top Left)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .tint(.blue)
                }
                
                // Save Button (Top Right)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save logic here
                        
                        
                        
                        dismiss()
                    }
                    .bold(true)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color(.systemBackground), for: .navigationBar)
            .sheet(isPresented: $showScannerSheet) {
                PlateScannerView()
            }
        }
        
    }
}

#Preview {
    AddNewEntryView()
}

struct VehicleTypeChooser: View {
    
    @State var selectedVehicleType: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pilih Kendaraan")
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 30) {
                    Image(systemName: "motorcycle.fill")
                        .font(.system(size: 30))
                    Text("Motor")
                }
                .frame(width: 150, height: 150)
                .foregroundColor(selectedVehicleType == "Motor" ? .white : Color(UIColor.systemGray3))
                .background(selectedVehicleType == "Motor" ? .blue : .clear)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
                .onTapGesture {
                    withAnimation {
                        selectedVehicleType = (selectedVehicleType == "Motor") ? nil : "Motor"
                    }
                }
                
                VStack(spacing: 30) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 30))
                    Text("Mobil")
                }
                .frame(width: 150, height: 150)
                .foregroundColor(selectedVehicleType == "Mobil" ? .white : Color(UIColor.systemGray3))
                .background(selectedVehicleType == "Mobil" ? .blue : .clear)
                .cornerRadius(15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                }
                .onTapGesture {
                    withAnimation {
                        selectedVehicleType = (selectedVehicleType == "Mobil") ? nil : "Mobil"
                    }
                }
            }
            .padding(.horizontal, 25)
        }
        .padding(16)
    }
}
