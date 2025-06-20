import SwiftUI

struct PhotoAnalysisResult {
    let undertone: UndertoneResult
    let skintone: SkintoneResult
    let skintoneGroup: String
    let rawImage: UIImage

    var summaryText: String {
        """
        Undertone: \(undertone.type.rawValue)
        Skintone: \(skintone.label)
        Skintone Group: \(skintoneGroup)

        Top Shirt Colors: \(undertone.shirtColors.joined(separator: ", "))
        Recommended Foundation Shades: \(skintone.shadeRecommendations.joined(separator: ", "))
        """
    }
}

struct UndertoneResult {
    let type: UndertoneType
    let accessoryColors: [String]
    let shirtColors: [String]
    let hairColors: [String]
}

enum UndertoneType: String {
    case warm, cool, neutral
}

struct SkintoneResult {
    let label: String
    let shadeRecommendations: [String]
}
