//
//  CaptureViewCamera.swift
//  Lumea
//
//  Created by Nicholas  on 14/06/25.
//

import SwiftUI
import AVFoundation

struct CaptureView: View {
    @StateObject private var viewModel = CaptureViewModel()
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
            
            // Dark overlay with hole
            Color.black.opacity(0.6)
                .mask {
                    Rectangle()
                        .overlay(
                            Ellipse()
                                .frame(width: 260, height: 360)
                                .blendMode(.destinationOut)
                        )
                        .compositingGroup()
                }
                .ignoresSafeArea()
            
            
            
            
            
            VStack {
                // Top bar buttons
                HStack(spacing: 16) {
                    statusButton(title: "Face Position", color: viewModel.isFaceCentered ? .green : .red)
                    statusButton(title: "Look Straight", color: viewModel.isFacingCamera ? .green : .red)
                    statusButton(
                        title: "Lighting",
                        color: viewModel.isBrightnessPass ? .green : .red)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Bottom instruction text
                Text("Align your face within the circle")
                    .font(.jakarta(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.blue)) //gatau bjir warnanya apa, tak bisa cek di figma kwakwaowokowa
                    .cornerRadius(12)
                
            }
            .padding(.horizontal)
        }
    }
    
    // Reusable status button
    @ViewBuilder
    private func statusButton(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(8)
    }
}
