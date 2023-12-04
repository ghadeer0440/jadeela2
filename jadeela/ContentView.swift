import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var isActive: Bool = false
    @State private var hairTypeResult: String = ""
    @State private var showCameraPermissionAlert = false


    var body: some View {
        NavigationView {
            ZStack{
                Color(UIColor(hex: "FFFBF8"))
                    .ignoresSafeArea()
            VStack {
                Text("Find your Hair type")
                    .bold()
                    .font(.system(size: 32))
                //    .padding(.bottom, 10.0)
                    .padding(.top, 20.0)

                Text("Your hair journey starts here")
                    .bold()
                    .font(.system(size: 21))
                    .padding(.bottom, 50.0)

                Text("Tips before taking a pic:")
                    .bold()
                    .font(.system(size: 21))

                Text("* Hair must be Dry")
                Text("* The photo must be stable")
                    .padding(.bottom, 50.0)


                VStack(spacing: 30) {
                    Button(action: {
                        openCamera()
                    }) {
                        HStack {
                            Text("Analyze your hair")
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
                    
                    
                    NavigationLink(
                        destination: Routine(),
                        label: {
                            HStack {
                                Text("Go to routine")
                                    .foregroundColor(.white)
                                    .padding(.leading, 20.0)

                                Image(systemName: "calendar.badge.checkmark")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                                    .padding(.leading, 10.0)

                            }
                            .frame(width: 200, height: 40)
                            .padding()
                            .background(Color(UIColor(hex: "8E6FCF")))
                            .cornerRadius(10)
                        }
                    )
                    
                }
                    
                    .sheet(isPresented: $isShowingCamera) {
                        #if targetEnvironment(simulator)
                        Text("Camera not available in the simulator")
                        #else
                        CameraViewController(isPresented: $isShowingCamera) { result in
                            hairTypeResult = result
                        }
                        #endif
                    }

                    NavigationLink(
                        destination: determineDestinationView(),
                        isActive: .constant(!hairTypeResult.isEmpty), // Navigate only if hairTypeResult is not empty
                        label: { EmptyView() }
                    )
                }
                .padding(.top, 20)
            }
//            .padding(.horizontal, 60)
            .navigationBarTitle("", displayMode: .inline)
        }
      .padding(.horizontal,60)

        .tint(Color(UIColor(hex: "8E6FCF")))
        .alert(isPresented: $showCameraPermissionAlert) {
                    Alert(
                        title: Text("Camera Permission Denied"),
                        message: Text("Please go to Settings and enable camera access to use this feature."),
                        primaryButton: .default(Text("Settings"), action: openSettings),
                        secondaryButton: .cancel()
                    )
                }

    } //body

    private func openCamera() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            #if targetEnvironment(simulator)
            print("Camera not available in the simulator")
            #else
            isShowingCamera = true
            #endif
        } else if status == .denied || status == .restricted {
            showCameraPermissionAlert = true
        } else if status == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isShowingCamera = true
                    } else {
                        showCameraPermissionAlert = true
                    }
                }
            }
        }
    }

    private func determineDestinationView() -> some View {
        switch hairTypeResult {
        case "Wavy":
            return AnyView(wavy())
        case "Curly":
            return AnyView(curly())
        case "Straight":
            return AnyView(straight())
        default:
            return AnyView(emptyResult())
        }
    }
}

private func openSettings() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
        return
    }
    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// CameraViewController.swift
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var onImageCapture: ((String) -> Void)? = nil
    let imageClassifier = MyImageClassifierModel()

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let cameraViewController = UIImagePickerController()
        cameraViewController.sourceType = .camera
        cameraViewController.delegate = context.coordinator
        imageClassifier.onImageCapture = onImageCapture
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
            if let uiImage = info[.originalImage] as? UIImage {
                classifyImage(uiImage)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }

        func classifyImage(_ image: UIImage) {
            parent.imageClassifier.predict(image: image) { result in
                self.parent.onImageCapture?(result)
                self.parent.isPresented = false
            }
        }
    }
}

// MyImageClassifierModel.swift
import CoreML
import Vision
import UIKit

class MyImageClassifierModel {
    private let model: MyImageClassifier
    var onImageCapture: ((String) -> Void)?

    init() {
        model = MyImageClassifier()
    }

    func predict(image: UIImage, completion: @escaping (String) -> Void) {
        guard let ciImage = CIImage(image: image),
              let pixelBuffer = pixelBuffer(from: ciImage) else {
            return
        }

        do {
            let modelInput = MyImageClassifierInput(image: pixelBuffer)
            let prediction = try model.prediction(input: modelInput)

            let detailedLabel = prediction.target
            let broadCategory = mapToBroadCategory(detailedLabel)

            completion(broadCategory)
        } catch {
            print("Error making prediction: \(error)")
        }
    }

    private func mapToBroadCategory(_ detailedLabel: String) -> String {
        switch detailedLabel {
        case "long Curly Hair", "short curly hair":
            return "Curly"
        case "long Straight Hair", "short straight hair":
            return "Straight"
        case "long Wavy Hair", "short wavy hair":
            return "Wavy"
        default:
            return "Unknown"
        }
    }

    private func pixelBuffer(from ciImage: CIImage) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?

        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: kCFBooleanTrue
        ]

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(ciImage.extent.size.width),
                                         Int(ciImage.extent.size.height),
                                         kCVPixelFormatType_32ARGB,
                                         attributes as CFDictionary,
                                         &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let context = CIContext()
        context.render(ciImage, to: buffer)

        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))

        return buffer
    }
}

//struct WavyResultView: View {
//    var body: some View {
//        Text("Wavy Hair Result View")
//    }
//}
//
//struct CurlyResultView: View {
//    var body: some View {
//        Text("Curly Hair Result View")
//    }
//}
//
//struct StraightResultView: View {
//    var body: some View {
//        Text("Straight Hair Result View")
//    }
//}

struct emptyResult: View {
    var body: some View {
        Text("wrong view")
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

struct MyImageClassifierModel_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
