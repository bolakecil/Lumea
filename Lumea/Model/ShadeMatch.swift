import Foundation

struct ShadeMatch {
    let name: String
    let hex: String
}

class ShadeMapper {
    private static let shadeData: [String: [String: [ShadeMatch]]] = [
        "Deep": [
            "WARM": [
                ShadeMatch(name: "W42 Warm Sand", hex: "#CBB864"),
                ShadeMatch(name: "W33 Honey Beige", hex: "#DFA37B"),
                ShadeMatch(name: "W32 Warm Beige", hex: "#DFAC81")
            ],
            "NEUTRAL": [
                ShadeMatch(name: "N70 Ebony", hex: "#6E4634"),
                ShadeMatch(name: "N50 Tan", hex: "#B1B068"),
                ShadeMatch(name: "N40 Sand", hex: "#D29376")
            ],
            "COOL": [
                ShadeMatch(name: "C62 Rich Cocoa", hex: "#815B4A"),
                ShadeMatch(name: "C51 Cool Tan", hex: "#A47C6F"),
                ShadeMatch(name: "C41 Cool Sand", hex: "#C58577")
            ]
        ],
        "Tan": [
            "WARM": [
                ShadeMatch(name: "W42 Warm Sand", hex: "#CBB864"),
                ShadeMatch(name: "W33 Honey Beige", hex: "#DFA37B"),
                ShadeMatch(name: "W32 Warm Beige", hex: "#DFAC81")
            ],
            "NEUTRAL": [
                ShadeMatch(name: "N70 Ebony", hex: "#6E4634"),
                ShadeMatch(name: "N50 Tan", hex: "#B1B068"),
                ShadeMatch(name: "N40 Sand", hex: "#D29376")
            ],
            "COOL": [
                ShadeMatch(name: "C62 Rich Cocoa", hex: "#815B4A"),
                ShadeMatch(name: "C51 Cool Tan", hex: "#A47C6F"),
                ShadeMatch(name: "C41 Cool Sand", hex: "#C58577")
            ]
        ],
        "Medium": [
            "WARM": [
                ShadeMatch(name: "W33 Honey Beige", hex: "#DFA37B"),
                ShadeMatch(name: "W32 Warm Beige", hex: "#DFAC81"),
                ShadeMatch(name: "W42 Warm Sand", hex: "#CBB864")
            ],
            "NEUTRAL": [
                ShadeMatch(name: "N40 Sand", hex: "#D29376"),
                ShadeMatch(name: "N50 Tan", hex: "#B1B068"),
                ShadeMatch(name: "N30 Natural Beige", hex: "#E0AC87")
            ],
            "COOL": [
                ShadeMatch(name: "C41 Cool Sand", hex: "#C58577"),
                ShadeMatch(name: "C31 Pink Beige", hex: "#D4A9A1"),
                ShadeMatch(name: "C51 Cool Tan", hex: "#A47C6F")
            ]
        ],
        "Light": [
            "WARM": [
                ShadeMatch(name: "W22 Warm Ivory", hex: "#E8CAAA"),
                ShadeMatch(name: "W12 Warm Marble", hex: "#F3DDC0"),
                ShadeMatch(name: "W32 Warm Beige", hex: "#DFAC81")
            ],
            "NEUTRAL": [
                ShadeMatch(name: "N10 Marble", hex: "#F3D0BB"),
                ShadeMatch(name: "N20 Ivory", hex: "#F4D4BE"),
                ShadeMatch(name: "N00 Porcelain", hex: "#F0E5DC")
            ],
            "COOL": [
                ShadeMatch(name: "C11 Pink Marble", hex: "#E6D2C9"),
                ShadeMatch(name: "C21 Pink Ivory", hex: "#EBB79E"),
                ShadeMatch(name: "C31 Pink Beige", hex: "#D4A9A1")
            ]
        ],
        "Fair": [
            "WARM": [
                ShadeMatch(name: "W12 Warm Marble", hex: "#F3DDC0"),
                ShadeMatch(name: "W22 Warm Ivory", hex: "#E8CAAA"),
                ShadeMatch(name: "W32 Warm Beige", hex: "#DFAC81")
            ],
            "NEUTRAL": [
                ShadeMatch(name: "N00 Porcelain", hex: "#F0E5DC"),
                ShadeMatch(name: "N20 Ivory", hex: "#F4D4BE"),
                ShadeMatch(name: "N10 Marble", hex: "#F3D0BB")
            ],
            "COOL": [
                ShadeMatch(name: "C11 Pink Marble", hex: "#E6D2C9"),
                ShadeMatch(name: "C21 Pink Ivory", hex: "#EBB79E"),
                ShadeMatch(name: "C31 Pink Beige", hex: "#D4A9A1")
            ]
        ]
    ]
    
    static func getShadeRecommendations(for undertone: String, skintoneGroup: String) -> [String] {
        guard let undertoneData = shadeData[skintoneGroup],
              let shades = undertoneData[undertone.uppercased()] else {
            return []
        }
        
        return shades.map { $0.name }
    }
    
    static func getShadeMatches(for undertone: String, skintoneGroup: String) -> [ShadeMatch] {
        guard let undertoneData = shadeData[skintoneGroup],
              let shades = undertoneData[undertone.uppercased()] else {
            return []
        }
        
        return shades
    }
}
