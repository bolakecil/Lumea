//
//  PhotoAnalysisResult.swift
//  Lumea
//
//  Created by Jessica Lynn on 13/06/25.
//
import SwiftUI

struct PhotoAnalysisResult {
    let undertone: UndertoneResult
    let skintone: SkintoneResult
    let rawImage: UIImage

    // Optional: auto generate report info here
    var summaryText: String {
        """
        Undertone: \(undertone.type.rawValue)
        Skintone: \(skintone.label)

        Top Shirt Colors: \(undertone.shirtColors.joined(separator: ", "))
        Recommended Foundation Shades: \(skintone.shadeRecommendations.joined(separator: ", "))
        """
    }
}

struct UndertoneResult {
    let type: UndertoneType
    let accessoryColors: [String] // e.g., ["Gold", "Rose Gold", "Copper"]
    let shirtColors: [String]     // e.g., ["Teal", "Berry", "Charcoal"]
    let hairColors: [String]      // e.g., ["Ash Brown", "Cool Black", "Platinum"]
}

enum UndertoneType: String {
    case warm, cool, neutral, olive
}

struct SkintoneResult {
    let label: String           // e.g., "#BEA07E"
    let shadeRecommendations: [String] // e.g., foundation codes/names
}
