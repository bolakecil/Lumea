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
    @Published var countdown: Int = 0
    @Published var showSheet = false
    @Published var capturedImage: UIImage?
    
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

        DispatchQueue.main.async {
            self.isBrightnessPass = isBrightnessPass
        }

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

            let alignedFace = results.contains { face in
                // Orientation check
                guard
                    let yaw = face.yaw?.doubleValue,
                    let roll = face.roll?.doubleValue,
                    let landmarks = face.landmarks,
                    let leftEye = landmarks.leftEye,
                    let nose = landmarks.nose,
                    let mouth = landmarks.outerLips
                else {
                    return false
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
                
                
                //Facing camera
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

                faceIsCentered = ellipseRect.contains(faceRect)

//                    print("🎯 Yaw: \(yaw), Roll: \(roll), Pitch Δ: \(pitchDeviation), Centered: \(faceIsCentered)")

                return isYawAligned && isRollAligned && isPitchAligned
            }

            DispatchQueue.main.async {
                self.isFacingCamera = alignedFace
                self.isFaceCentered = faceIsCentered
            }

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

    private func capturePhoto(from sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let image = UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .leftMirrored)
            DispatchQueue.main.async {
                self.capturedImage = image
                self.showSheet = true
            }
        }
    }
    
}
