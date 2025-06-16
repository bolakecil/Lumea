//
//  CaptureViewModel.swift
//  Lumea
//
//  Created by Nicholas  on 14/06/25.
//

import SwiftUI
import CoreImage
import AVFoundation
import Vision

struct CameraPreview: UIViewRepresentable {
    class CameraView: UIView {
        private var previewLayer: AVCaptureVideoPreviewLayer?

        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }

        func configure(with session: AVCaptureSession) {
            videoPreviewLayer.session = session
            videoPreviewLayer.videoGravity = .resizeAspectFill
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraView {
        let view = CameraView()
        view.configure(with: session)
        return view
    }

    func updateUIView(_ uiView: CameraView, context: Context) {
        uiView.configure(with: session)
    }
    
}

class CaptureViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isBrightnessPass: Bool = false
    @Published var isFacingCamera: Bool = false
    @Published var isFaceCentered: Bool = false
    @Published var skintoneLabel: String = ""
    @Published var undertoneLabel: String = ""
    @Published var result: PhotoAnalysisResult?

    @Published var countdown: Int = 0
    @Published var showSheet = false
    @Published var capturedImage: UIImage?
    @Published var instructionText: String = "Align your face within the circle"
    
    private var capturedRawImage: UIImage?
    private var pendingSkintone: SkintoneResult?
    private var pendingUndertone: UndertoneResult?
    private var pendingSkintoneGroup: String?

    
    private let modelProcessor = ModelProcessor()
    
    
    
    
    private func updateInstructionText() {
        if !isFaceCentered {
            instructionText = "Align your face within the circle"
        } else if !isFacingCamera {
            instructionText = "Look straight at the camera"
        } else if !isBrightnessPass {
            instructionText = "Brighten the room to see your skin clearly"
        } else {
            instructionText = "Perfect! Ready to capture"
        }
    }
    
    
    private var greenStateStart: Date?
    private var isCountingDown = false
    private var countdownTimer: Timer?

    let session = AVCaptureSession()
    private let context = CIContext()
    
    private let faceDetectionRequest: VNDetectFaceLandmarksRequest = {
        let request = VNDetectFaceLandmarksRequest()
        request.revision = VNDetectFaceLandmarksRequestRevision3
        return request
    }()

    override init() {
        super.init()
        configureCamera()
    }

    private func configureCamera() {
        session.beginConfiguration()

        // Use front camera
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else {
            print("Unable to access front camera")
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    private func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.stopRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let extent = ciImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.width, w: extent.height)

        guard let filter = CIFilter(name: "CIAreaAverage") else { return }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(inputExtent, forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage else { return }
        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        let avgBrightness = (Double(bitmap[0]) + Double(bitmap[1]) + Double(bitmap[2])) / 3.0
    
        let isBrightnessPass = avgBrightness > 80

//        DispatchQueue.main.async {
//            self.isBrightnessPass = isBrightnessPass
//            self.isFacingCamera = alignedFace
//            self.isFaceCentered = faceIsCentered
//            self.updateInstructionText() // Explicitly update the instruction
//        }

        // Face detection
        let faceDetectionRequest = VNDetectFaceLandmarksRequest()
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])

        func averageY(from region: VNFaceLandmarkRegion2D) -> CGFloat {
            let points = region.normalizedPoints
            guard !points.isEmpty else { return 0 }
            return points.map { $0.y }.reduce(0, +) / CGFloat(points.count)
        }
    
        func isFaceFullyInsideEllipse(faceRect: CGRect, ellipseRect: CGRect) -> Bool {
            func isPointInEllipse(_ point: CGPoint, in rect: CGRect) -> Bool {
                let dx = point.x - rect.midX
                let dy = point.y - rect.midY
                let rx = rect.width / 2
                let ry = rect.height / 2
                return (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry) <= 1
            }

            let corners = [
                faceRect.origin,
                CGPoint(x: faceRect.maxX, y: faceRect.minY),
                CGPoint(x: faceRect.minX, y: faceRect.maxY),
                CGPoint(x: faceRect.maxX, y: faceRect.maxY)
            ]

            return corners.allSatisfy { isPointInEllipse($0, in: ellipseRect) }
        }

        do {
            try handler.perform([faceDetectionRequest])
            guard let results = faceDetectionRequest.results else {
                DispatchQueue.main.async {
                    self.isFacingCamera = false
                    self.isFaceCentered = false
                }
                return
            }
            
            var faceIsCentered: Bool = false
            var alignedFace: Bool = false

            for face in results {
                guard
                    let yaw = face.yaw?.doubleValue,
                    let roll = face.roll?.doubleValue,
                    let landmarks = face.landmarks,
                    let leftEye = landmarks.leftEye,
                    let nose = landmarks.nose,
                    let mouth = landmarks.outerLips
                else {
                    continue
                }

                let isYawAligned = abs(yaw) < 0.05
                let isRollAligned = abs(roll) < 0.05

                let eyeY = averageY(from: leftEye)
                let noseY = averageY(from: nose)
                let mouthY = averageY(from: mouth)

                let eyeToNose = noseY - eyeY
                let noseToMouth = mouthY - noseY
                let pitchDeviation = abs(eyeToNose - noseToMouth)
                let isPitchAligned = pitchDeviation < 0.05

                let screenSize = UIScreen.main.bounds.size
                let ellipseRect = CGRect(
                    x: (screenSize.width - 460) / 2,
                    y: (screenSize.height - 660) / 2,
                    width: 460,
                    height: 660
                )

                let faceRect = CGRect(
                    x: face.boundingBox.origin.x * screenSize.width,
                    y: (1 - face.boundingBox.origin.y - face.boundingBox.size.height) * screenSize.height,
                    width: face.boundingBox.size.width * screenSize.width,
                    height: face.boundingBox.size.height * screenSize.height
                )

                if isYawAligned && isRollAligned && isPitchAligned {
                    alignedFace = true

                    if ellipseRect.contains(faceRect) {
                        faceIsCentered = true
                    }

                    break
                }

            }

            DispatchQueue.main.async {
                self.isFacingCamera = alignedFace
                self.isFaceCentered = faceIsCentered
                self.isBrightnessPass = isBrightnessPass
                self.updateInstructionText()
            }


//            DispatchQueue.main.async {
//                self.isFacingCamera = alignedFace
//                self.isFaceCentered = faceIsCentered
//            }

        } catch {
            print("❌ Face detection failed:", error)
            DispatchQueue.main.async {
                self.isFacingCamera = false
                self.isFaceCentered = false
            }
        }
    
        DispatchQueue.main.async {
            self.checkGreenState(sampleBuffer)
        }
    }

    private func checkGreenState(_ sampleBuffer: CMSampleBuffer) {
        if isBrightnessPass && isFacingCamera && isFaceCentered {
            if greenStateStart == nil {
                greenStateStart = Date()
            }
            
            if let start = greenStateStart, Date().timeIntervalSince(start) >= 1.0, !isCountingDown {
//                startCountdown(sampleBuffer)
            }
            
            DispatchQueue.main.async {
                self.capturePhoto(from: sampleBuffer)
                self.stopCamera()
            }
            
        } else {
            greenStateStart = nil
//            stopCountdown()
        }
    }
//    
//    private func startCountdown(_ sampleBuffer: CMSampleBuffer) {
//        isCountingDown = true
//        countdown = 3
//
//        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//            self.countdown -= 1
//            if self.countdown <= 0 {
//                timer.invalidate()
//                self.capturePhoto(from: sampleBuffer)
//                self.isCountingDown = false
//            }
//        }
//    }
//
//    private func stopCountdown() {
//        countdownTimer?.invalidate()
//        isCountingDown = false
//        countdown = 0
//    }
    
    private func extractCheekRegion(from face: VNFaceObservation, in image: CIImage) -> CIImage? {
        guard let landmarks = face.landmarks,
              let contour = landmarks.faceContour else { return nil }
        
        // Pick one cheek point (e.g., left cheek around index 5)
        let cheekPoint = contour.normalizedPoints[5] // adjust index if needed
        
        // Convert normalized point to image coordinates
        let boundingBox = face.boundingBox
        let imageSize = image.extent.size
        
        let x = boundingBox.origin.x * imageSize.width + cheekPoint.x * boundingBox.width * imageSize.width
        let y = (1 - boundingBox.origin.y - boundingBox.height + cheekPoint.y * boundingBox.height) * imageSize.height
        
        // Define a small square around that point (e.g., 40x40 pixels)
        let cheekRect = CGRect(x: x - 20, y: y - 20, width: 40, height: 40)
        
        // Crop it
        return image.cropped(to: cheekRect)
    }
    
    private func detectSkintone(from image: UIImage) {
        guard let pixelBuffer = image.pixelBuffer() else {
            print("❌ Failed to convert image to pixelBuffer")
            return
        }
        modelProcessor?.process(pixelBuffer: pixelBuffer) { result in
            DispatchQueue.main.async {
                self.skintoneLabel = result ?? "Unknown"
//                print("🎨 Skintone: \(self.skintoneLabel)")
            }
        }
    }
    
    private func detectSkinUndertone(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        // Run Vision again on the image to get face and landmarks
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .leftMirrored)
        let request = VNDetectFaceLandmarksRequest()

        do {
            try handler.perform([request])
            guard let face = request.results?.first else { return }

            if let cheekCrop = extractCheekRegion(from: face, in: ciImage) {
                // Use same CIAreaAverage logic
                let avgColor = cheekCrop.applyingFilter("CIAreaAverage", parameters: [kCIInputExtentKey: CIVector(cgRect: cheekCrop.extent)])
                var bitmap = [UInt8](repeating: 0, count: 4)
                let context = CIContext()
                context.render(avgColor,
                               toBitmap: &bitmap,
                               rowBytes: 4,
                               bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                               format: .RGBA8,
                               colorSpace: CGColorSpaceCreateDeviceRGB())

                let r = Double(bitmap[0]) / 255
                let g = Double(bitmap[1]) / 255
                let b = Double(bitmap[2]) / 255

                let undertone = classifySkinUndertone(fromRGB: r, g: g, b: b)
                self.undertoneLabel = undertone
//                print("📸 Detected undertone from cheek: \(undertone)")
            }
        } catch {
            print("❌ Landmark detection failed:", error)
        }
    }

    private func classifySkinUndertone(fromRGB r: Double, g: Double, b: Double) -> String {
        // Convert RGB to CIELAB (you can use a simple conversion or a library for better accuracy)
        let lab = rgbToCIELAB(r, g, b)
        
        // Based on CIELAB values, classify undertone
        if lab.b < -20 {
            return "Cool"
        } else if lab.b > 20 {
            return "Warm"
        } else {
            return "Neutral"
        }
    }

    // Simple RGB to CIELAB conversion function (you can improve it with better math)
    private func rgbToCIELAB(_ r: Double, _ g: Double, _ b: Double) -> (L: Double, a: Double, b: Double) {
        // Convert RGB to XYZ
        let x = 0.4124564 * r + 0.3575761 * g + 0.1804375 * b
        let y = 0.2126729 * r + 0.7151522 * g + 0.0721750 * b
        let z = 0.0193339 * r + 0.1191920 * g + 0.9503041 * b
        
        // Normalize XYZ
        let xn = 0.95047
        let yn = 1.00000
        let zn = 1.08883
        
        let xNorm = x / xn
        let yNorm = y / yn
        let zNorm = z / zn
        
        // Convert to CIELAB
        let fx: Double = (xNorm > 0.008856) ? pow(xNorm, 1/3) : (xNorm * 903.3 + 16) / 116
        let fy: Double = (yNorm > 0.008856) ? pow(yNorm, 1/3) : (yNorm * 903.3 + 16) / 116
        let fz: Double = (zNorm > 0.008856) ? pow(zNorm, 1/3) : (zNorm * 903.3 + 16) / 116
        
        let L = 116 * fy - 16
        let a = 500 * (fx - fy)
        let b = 200 * (fy - fz)
        
        return (L, a, b)
    }
    
    private func createAnalysisResult() {
        guard let image = capturedRawImage,
              !skintoneLabel.isEmpty,
              !undertoneLabel.isEmpty else {
            print("❌ Missing data for analysis result")
            return
        }
        
        // Direct CSV lookup since ML model should return exact hex values
        let skintoneGroup = CSVSkinMapper.getSkintoneGroup(for: skintoneLabel)
        
        if !CSVSkinMapper.isValidSkinHex(skintoneLabel) {
            print("⚠️ Warning: Unexpected hex color from ML model: \(skintoneLabel)")
        }
        
        // Use your RGB-detected undertone (from detectSkinUndertone)
        let undertone = undertoneLabel // "Warm", "Cool", "Neutral"
        
        // Get shade recommendations using both
        let shadeRecommendations = ShadeMapper.getShadeRecommendations(
            for: undertone,
            skintoneGroup: skintoneGroup
        )
        
        // Create the result
        let undertoneType = UndertoneType(rawValue: undertone.lowercased()) ?? .neutral
        
        let analysisResult = PhotoAnalysisResult(
            undertone: UndertoneResult(
                type: undertoneType,
                accessoryColors: [],
                shirtColors: [],
                hairColors: []
            ),
            skintone: SkintoneResult(
                label: skintoneLabel, // ML-detected hex color
                shadeRecommendations: shadeRecommendations
            ),
            skintoneGroup: skintoneGroup, // CSV-mapped group
            rawImage: image
        )
        
        print("🎯 Final result:")
        print("   Skintone: \(skintoneLabel) → Group: \(skintoneGroup)")
        print("   Undertone: \(undertone) (from RGB analysis)")
        print("   Recommendations: \(shadeRecommendations)")
        
        DispatchQueue.main.async {
            self.result = analysisResult
        }
    }

    private func capturePhoto(from sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .leftMirrored)
            DispatchQueue.main.async {
                self.capturedImage = image
                self.capturedRawImage = image  // needed later
                self.showSheet = true

                self.detectSkintone(from: image)
                self.detectSkinUndertone(from: image)
                print(self.skintoneLabel)
                print(self.undertoneLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.createAnalysisResult()
                }
            }

        }
    }
}
