import SwiftUI

extension UIImage {
    func pixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: true,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: true] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let width = Int(size.width)
        let height = Int(size.height)

        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)

        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(buffer, [])

        let context = CIContext()
        context.render(CIImage(image: self)!,
                       to: buffer)

        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}
