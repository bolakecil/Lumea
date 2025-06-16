//
//  RoundedCorners.swift
//  Lumea
//
//  Created by Jessica Lynn on 16/06/25.
//
import SwiftUI

struct RoundedCorners: Shape {
    var topLeft: CGFloat = 0.0
    var topRight: CGFloat = 0.0
    var bottomLeft: CGFloat = 0.0
    var bottomRight: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Start from top-left
        path.move(to: CGPoint(x: topLeft, y: 0))
        
        // Top edge
        path.addLine(to: CGPoint(x: w - topRight, y: 0))
        path.addArc(center: CGPoint(x: w - topRight, y: topRight), 
                   radius: topRight, 
                   startAngle: Angle(degrees: -90), 
                   endAngle: Angle(degrees: 0), 
                   clockwise: false)
        
        // Right edge
        path.addLine(to: CGPoint(x: w, y: h - bottomRight))
        path.addArc(center: CGPoint(x: w - bottomRight, y: h - bottomRight), 
                   radius: bottomRight, 
                   startAngle: Angle(degrees: 0), 
                   endAngle: Angle(degrees: 90), 
                   clockwise: false)
        
        // Bottom edge
        path.addLine(to: CGPoint(x: bottomLeft, y: h))
        path.addArc(center: CGPoint(x: bottomLeft, y: h - bottomLeft), 
                   radius: bottomLeft, 
                   startAngle: Angle(degrees: 90), 
                   endAngle: Angle(degrees: 180), 
                   clockwise: false)
        
        // Left edge
        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addArc(center: CGPoint(x: topLeft, y: topLeft), 
                   radius: topLeft, 
                   startAngle: Angle(degrees: 180), 
                   endAngle: Angle(degrees: 270), 
                   clockwise: false)

        return path
    }
}
