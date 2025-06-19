import SwiftUI

struct VisualAssets {
    let shadeRecommendations: [String]  // Add this
    let shirtAsset: String
    let shirtAssetLabel: String
    let hairAsset: String
    let hairAssetLabel: String
    let accessoryAsset: String
    let AccessoriesAssetLabel: String
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
        let undertone = result.undertone.type
        let undertoneType = result.undertone.type.rawValue.capitalized // "Warm"
        let shadeRecommendations = ShadeMapper.getShadeRecommendations(
            for: result.undertone.type.rawValue,
            skintoneGroup: result.skintoneGroup
        )
        let shirtAsset = "Shirt\(undertoneType)"           // "ShirtWarm"
        let hairAsset = "Hair\(undertoneType)"             // "HairWarm"
        let accessoryAsset = "Accessory\(undertoneType)"   // "AccessoryWarm"
        
        let shirtLabel: String
        let hairLabel: String
        let accessoryLabel: String
        
        switch undertone {
        case .cool:
            shirtLabel = "Blue Shirt"
            hairLabel = "Blonde Hair"
            accessoryLabel = "Silver Jewelry"
        case .warm:
            shirtLabel = "Orange Shirt"
            hairLabel = "Ginger Hair"
            accessoryLabel = "Gold Jewelry"
        case .neutral:
            shirtLabel = "White Shirt"
            hairLabel = "Dark Brown Hair"
            accessoryLabel = "Silver Jewelry"
        }
        
        return VisualAssets(
            shadeRecommendations: shadeRecommendations,
            shirtAsset: shirtAsset,
            shirtAssetLabel: shirtLabel,
            hairAsset: hairAsset,
            hairAssetLabel: hairLabel,
            accessoryAsset: accessoryAsset,
            AccessoriesAssetLabel: accessoryLabel
        )
    }
}
