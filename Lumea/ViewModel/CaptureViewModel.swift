//
//  CaptureViewModel.swift
//  Lumea
//
//  Created by Nicholas  on 14/06/25.
//

import SwiftUI
import CoreImage
import AVFoundation

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
    @Published var brightness: Double = 0.0

    let session = AVCaptureSession()
    private let context = CIContext()

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
        session.startRunning()
    }

    // Called for each frame captured
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

        DispatchQueue.main.async {
            self.brightness = avgBrightness
            print("💡 Brightness: \(avgBrightness)")
        }
    }
}
