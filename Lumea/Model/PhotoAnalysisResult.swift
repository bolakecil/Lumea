import SwiftUI

struct PhotoAnalysisResult {
    let undertone: UndertoneResult
    let skintone: SkintoneResult
    let skintoneGroup: String  // Add this: "Deep", "Tan", "Medium", "Light", "Fair"
    let rawImage: UIImage

    // Optional: auto generate report info here
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
    let label: String           // e.g., "#BEA07E"
    let shadeRecommendations: [String] // e.g., foundation codes/names
}
