//
//  ShadeOption.swift
//  Lumea
//
//  Created by Jessica Lynn on 17/06/25.
//


import SwiftUI

struct ShadeOption: Identifiable {
    let id = UUID()
    let name: String
    let hex: String
    let imageName: String

    var color: UIColor {
        UIColor(named: hex) ?? .brown
    }

    static let placeholder = ShadeOption(name: "Default", hex: "#9D7A54", imageName: "default_swipe")
}
