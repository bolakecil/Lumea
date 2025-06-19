import Foundation

class CSVSkinMapper {
    // Based on your CSV - only mapping hex to skintone groups
    private static let skinGroupMappings: [String: String] = [
        "#373028": "Deep",
        "#422811": "Deep",
        "#513B2E": "Tan",
        "#6F503C": "Tan",
        "#81654F": "Medium",
        "#9D7A54": "Medium",
        "#BEA07E": "Light",
        "#E5C8A6": "Light",
        "#E7C1B8": "Fair",
        "#F3DAD6": "Fair",
        "#FBF2F3": "Fair"
    ]
    
    static func getSkintoneGroup(for hexColor: String) -> String {
        return skinGroupMappings[hexColor] ?? "Medium" // fallback
    }
    
    static func isValidSkinHex(_ hexColor: String) -> Bool {
        return skinGroupMappings[hexColor] != nil
    }
}
