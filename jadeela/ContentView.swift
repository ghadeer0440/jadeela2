//
//  ContentView.swift
//  jadeela
//
//  Created by Ghadeer on 23/11/2023.
//
import SwiftUI
import AVFoundation
import Photos

struct ContentView: View {

    @State private var isShowingCamera = false
    @State private var isActive: Bool = false
    @State private var hairTypeActive = false

    var body: some View {
        NavigationStack {
            
            ZStack {
                Color(UIColor(hex: "FFFBF8"))
                    .ignoresSafeArea()
                
                VStack {
                    Text("Find your Hair Problems")
                        .bold()
                        .font(.system(size: 32))
                        .padding(.bottom, 10.0)
                        .padding(.top, 10.0)

                    Text("........")
                        .bold()
                        .font(.system(size: 21))
                        .padding(.bottom, 50.0)
                    
                    Text("Tips before taking a pic:")
                        .bold()
                        .font(.system(size: 21))
                    
                    Text("* Hair must be Dry")
                    Text("* The photo must be stable")
                    
                    VStack(spacing: 30) {
                        Button(action: {
                            openCamera()
                        }) {
                            HStack {
                                Text("Analysis your hair")
                                    .foregroundColor(.white)
                                Image(systemName: "camera.circle")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200, height: 40)
                            .padding()
                            .background(Color(UIColor(hex: "8E6FCF")))
                            .cornerRadius(10)
                        }
                        .padding(.top, 50.0)
                        .buttonStyle(PlainButtonStyle())
                        
                       // Text("__________ OR __________")
                        
                        Button(action: {
                            isActive = true
                        }) {
                            HStack {
                                Text("Go to routine")
                                    .foregroundColor(.white)
                                    .padding(.leading, 20.0)
                                
                                Image(systemName: "calendar.badge.checkmark")
                                    .padding(.leading, 20.0)
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200, height: 40)
                            .padding()
                            .background(Color(UIColor(hex: "8E6FCF")))
                            .cornerRadius(10)
                        }
                       
                        .buttonStyle(PlainButtonStyle())
                        
            NavigationLink(
                destination: Routine(),
                
     //  .navigationBarBackButtonHidden(true) // Hide back button in the destination view
   //  .navigationBarHidden(true), // Hide navigation bar in the destination view
                isActive: $isActive,
            label: { EmptyView() }
                        )
                    }
                    .padding(.top, 20)
                }
               // .padding(.horizontal, 50)
            }
            .sheet(isPresented: $isShowingCamera) {
                #if targetEnvironment(simulator)
                Text("Camera not available in the simulator")
                #else
                CameraViewController(isPresented: $isShowingCamera)
                #endif
            }
        } 
   .padding(.horizontal, 60)
        .tint(Color(UIColor(hex: "8E6FCF")))

        
    } //body
    
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
        let alertController = UIAlertController(
            title: "Camera Access Required",
            message: "Please grant camera access in Settings to use this feature.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
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

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

#Preview {
    ContentView()
}
