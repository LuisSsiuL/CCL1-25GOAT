import SwiftUI
import AVFoundation
import Vision

struct PlateScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var recognizedText: String = "Menunggu hasil scan..."
    @State var presentedText: String = "Tidak terdeteksi plat"
    @State var isPresentedPlateDetected: Bool = false
    @State var isPresentedPlateNotDetected: Bool = false
    @State var isNewEntry: Bool = false
    
    @Binding var plateNumber: String
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                CameraView(recognizedText: $recognizedText)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        CameraView(recognizedText: $recognizedText).requestCameraPermission()
                    }
                
                Text("Plat Nomor Terdeteksi:")
                    .padding(.top)
                    .foregroundStyle(Color.white)
                Text(recognizedText)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Button {
                    
                    presentedText = recognizedText
                    if (presentedText == "Menunggu hasil scan..." || presentedText == "Tidak terdeteksi plat") {
                        isPresentedPlateNotDetected = true
                    } else {
                        isPresentedPlateDetected = true
                        print("detected: \(isPresentedPlateDetected)")
                    }
                    print("Alert triggered: \(presentedText)")
                } label: {
                    Image(systemName: "inset.filled.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                }
                .alert(isPresented: $isPresentedPlateNotDetected) {
                    Alert(title: Text("Plat Tidak Terdeteksi"), message: Text("Arahkan kamera ke plat nomor kendaraan"), dismissButton: .default(Text("Coba Lagi")))
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                     
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Back")
                        }
                    }
                }
                .toolbarBackgroundVisibility(.visible)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarTitleDisplayMode(.inline)
            }
            .background(Color.black)
        }
        .alert(isPresented: $isPresentedPlateDetected) {
            print("is detected")
            return Alert(title: Text("Lanjutkan dengan Hasil Scan"), message: Text("Number plate terdeteksi sebagai: \(String(describing: presentedText)). Lanjutkan?"), primaryButton: .default(Text("Lanjut"), action: {
                // pass data to addnewentry
                plateNumber = presentedText
                dismiss()
            }), secondaryButton: .cancel(Text("Kembali"))
            )
        }
    }
}

struct CameraView: UIViewRepresentable {
    @Binding var recognizedText: String
    
    func requestCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    
                } else {
                    // IF DENIED -> DISMISS THIS VIEW
                    print("denied")
                }
            }
        case .authorized:
            // only for debugging (delete)
            print("permission already granted")
        case .denied, .restricted:
            // pop up instruction to enable camera from settings, then dismiss this view
            print("permission already denied")
        @unknown default:
            break
        }
    }
    
    class CameraCoordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            recognizeText(in: pixelBuffer)
        }
        
        private func recognizeText(in image: CVPixelBuffer) {
            
            let requestHandler = VNImageRequestHandler(ciImage: CIImage(cvPixelBuffer: image), options: [:])
            
            let textRecognitionRequest = VNRecognizeTextRequest { request, error in
                
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                
                let bestObservation = results.first ?? VNRecognizedTextObservation()
                
                DispatchQueue.main.async {
                    self.parent.recognizedText = bestObservation.topCandidates(1).first?.string ?? "Tidak terdeteksi plat"
                }
            }
            
            do {
                try requestHandler.perform([textRecognitionRequest])
            } catch {
                print("Failed to perform text recognition: \(error.localizedDescription)")
            }
        }
    }
    
    func makeCoordinator() -> CameraCoordinator {
        return CameraCoordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let cameraView = CameraUIView()
        cameraView.setupCameraPreview(sessionDelegate: context.coordinator)
        return cameraView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

class CameraUIView: UIView {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupCameraPreview(sessionDelegate: AVCaptureVideoDataOutputSampleBufferDelegate) {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let videoDeviceInput: AVCaptureDeviceInput
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        // ??? fix this if error
        if (captureSession?.canAddInput(videoDeviceInput) == true) {
            captureSession?.addInput(videoDeviceInput)
        } else {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(sessionDelegate, queue: DispatchQueue(label: "com.example.camera-preview-delegate-queue"))
        
        if (captureSession?.canAddOutput(videoDataOutput) == true) {
            captureSession?.addOutput(videoDataOutput)
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = bounds
        self.layer.addSublayer(previewLayer!)
        previewLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(previewLayer!)
        
        captureSession?.startRunning()
        print("DEBUG: capture session started")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

#Preview {
    DashboardView()
}
