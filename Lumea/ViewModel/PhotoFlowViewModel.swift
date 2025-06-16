import SwiftUI

struct VisualAssets {
    let shadeRecommendations: [String]  // Add this
    let shirtAsset: String
    let hairAsset: String
    let accessoryAsset: String
}

class PhotoFlowViewModel: ObservableObject {
    enum Step {
        case start, guide, capture, result
    }

    @Published var step: Step = .start
    @Published var capturedImage: UIImage?
    @Published var result: PhotoAnalysisResult?

    private let model = try! modelAFAD25iter(configuration: .init())

    func proceedToGuide() {
        step = .guide
    }

    func takePhoto(_ image: UIImage) {
        self.capturedImage = image
        analyze(image)
    }

    private func analyze(_ image: UIImage) {
        // Convert to CVPixelBuffer and run ML
        // Update `result` and `step`
        step = .result
    }

    func resetFlow() {
        step = .start
        capturedImage = nil
        result = nil
    }
}

extension PhotoFlowViewModel {
    func resolvedAssets(for result: PhotoAnalysisResult) -> VisualAssets {
        let undertoneType = result.undertone.type.rawValue.capitalized // "Warm"
        let shadeRecommendations = ShadeMapper.getShadeRecommendations(
            for: result.undertone.type.rawValue,
            skintoneGroup: result.skintoneGroup
        )
        let shirtAsset = "Shirt\(undertoneType)"           // "ShirtWarm"
        let hairAsset = "Hair\(undertoneType)"             // "HairWarm"
        let accessoryAsset = "Accessory\(undertoneType)"   // "AccessoryWarm"
        
        return VisualAssets(
            shadeRecommendations: shadeRecommendations,
            shirtAsset: shirtAsset,
            hairAsset: hairAsset,
            accessoryAsset: accessoryAsset
        )
    }
}
