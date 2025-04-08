import SwiftUI
import AVFoundation
import Vision

struct PlateScannerView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var recognizedText: String = "Menunggu hasil scan..."
    @State private var presentedText: String?
    @State private var isPresented: Bool = false
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                CameraView(recognizedText: $recognizedText)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        CameraView.init(recognizedText: $recognizedText).requestCameraPermission()
                    }
                
                Text("Plat Nomor Terdeteksi:")
                    .padding(.top)
                Text(recognizedText)
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.blue)
                    .font(.headline)
                
                Button {
                    isPresented = true
                    presentedText = recognizedText
                    
                    // presentedText will be passed back to New Entry Page
                    
                } label: {
                    Image(systemName: "inset.filled.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue)
                }
                // ALERT IS PLACEHOLDER
                .alert(isPresented: $isPresented) {
                    Alert(title: Text("Captured Text"), message: Text(presentedText ?? "???"), dismissButton: .cancel())
                }
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Scanner").font(.headline)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Back")
                        }
                    }
                }
            }
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
        
        func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            recognizeText(in: pixelBuffer)
        }
        
        private func recognizeText(in image: CVPixelBuffer) {
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
            
            let textRecognitionRequest = VNRecognizeTextRequest { request, error in
                
                guard let results = request.results as? [VNRecognizedTextObservation] else { return }
                
                let bestObservation = results.first ?? VNRecognizedTextObservation()
                
                DispatchQueue.main.async {
                    self.parent.recognizedText = bestObservation.topCandidates(1).first?.string ?? "No Text Found"
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
    PlateScannerView()
}
