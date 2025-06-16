//
//  CaptureViewCamera.swift
//  Lumea
//
//  Created by Nicholas  on 14/06/25.
//

import SwiftUI
import AVFoundation

struct CaptureView: View {
    let photoFlowViewModel: PhotoFlowViewModel
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
                                .frame(width: 460, height: 660)
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
                Text(viewModel.instructionText)
                    .font(.jakarta(size: 16))
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.background)
                    .cornerRadius(12)
                    .padding(.bottom, 90)
                
                
                
            }
            .padding(.horizontal)
        }
//        .sheet(isPresented: $viewModel.showSheet) {
//            if let image = viewModel.capturedImage {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            }
//        }
        .onReceive(viewModel.$result) { result in
            if let result = result {
                // Pass the result to PhotoFlowViewModel and navigate to result
                photoFlowViewModel.result = result
                photoFlowViewModel.step = .result
            }
        }
    }
    
    // Reusable status button
    @ViewBuilder
    private func statusButton(title: String, color: Color) -> some View {
        Text(title)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(color)
            .cornerRadius(10)
    }
}

//#Preview {
//    CaptureView()
//}
