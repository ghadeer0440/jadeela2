/*import SwiftUI
import AVFoundation
import Photos

struct Camera: View {
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack {
            Button(action: {
                openCamera()
            }) {
                Text("Open Camera")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $isShowingCamera) {
            #if targetEnvironment(simulator)
            Text("Camera not available in the simulator")
            #else
            CameraViewController(isPresented: $isShowingCamera)
            #endif
        }
    }
    
    private func openCamera() {
        #if targetEnvironment(simulator)
        print("Camera not available in the simulator")
        #else
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .authorized:
            isShowingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        isShowingCamera = true
                    }
                }
            }
        case .denied, .restricted:
            showCameraAccessDeniedAlert()
        @unknown default:
            break
        }
        #endif
    }
    
    private func showCameraAccessDeniedAlert() {
        // Show an alert indicating that camera access is denied or restricted.
        // You can implement this part based on your specific UI requirements.
    }
}

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = .camera
        cameraViewController.delegate = context.coordinator
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Handle the captured image or video here
            // You can implement this part based on your specific requirements
            
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}


#Preview {
    Camera()
} */
