import CoreML
import Vision

class ModelProcessor {
    private let model: VNCoreMLModel

    init?() {
        guard let mlModel = try? modelAFAD25iter(configuration: MLModelConfiguration()).model,
              let vnModel = try? VNCoreMLModel(for: mlModel) else {
            return nil
        }
        self.model = vnModel
    }

    func process(pixelBuffer: CVPixelBuffer, completion: @escaping (String?) -> Void) {
        let request = VNCoreMLRequest(model: model) { request, _ in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                completion(nil)
                return
            }
            completion(topResult.identifier)
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}
