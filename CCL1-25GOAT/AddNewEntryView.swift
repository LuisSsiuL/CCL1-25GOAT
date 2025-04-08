import SwiftUI
import SwiftData

struct AddNewEntryView: View {
    @State var plateNumber: String = " "
    @Environment(\.dismiss) var dismiss
    @State private var selectedVehicle: String? = nil
    @State private var text = ""
    @State private var category: String = ""  // New state for category text field
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
                            
                            TextField("Plate Number", text: .constant(""), prompt: Text("Write your plate number"))
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
                        .foregroundColor(selectedVehicle == "Motor" ? .white : Color(UIColor.systemGray3))
                        .background(selectedVehicle == "Motor" ? .blue : .clear)
                        .cornerRadius(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                        }
                        .onTapGesture {
                            withAnimation {
                                selectedVehicle = (selectedVehicle == "Motor") ? nil : "Motor"
                            }
                        }
                        
                        VStack(spacing: 30) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 30))
                            Text("Mobil")
                        }
                        .frame(width: 150, height: 150)
                        .foregroundColor(selectedVehicle == "Mobil" ? .white : Color(UIColor.systemGray3))
                        .background(selectedVehicle == "Mobil" ? .blue : .clear)
                        .cornerRadius(15)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                        }
                        .onTapGesture {
                            withAnimation {
                                selectedVehicle = (selectedVehicle == "Mobil") ? nil : "Mobil"
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(16)
                
                // New Section: Tambahkan Category
                VStack(alignment: .leading, spacing: 16) {
                    Text("Tambahkan Category")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    ZStack(alignment: .leading) {
                        TextField("", text: $category)
                            .padding(8)
                        if category.isEmpty {
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
                        TextEditor(text: $text)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
                            }
                            .font(.subheadline)
                        if text.isEmpty {
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
