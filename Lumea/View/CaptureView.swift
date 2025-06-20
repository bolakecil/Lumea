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
                HStack(spacing: 16) {
                    statusButton(title: "Face Position", color: viewModel.isFaceCentered ? .green : .red)
                    statusButton(title: "Look Straight", color: viewModel.isFacingCamera ? .green : .red)
                    statusButton(
                        title: "Lighting",
                        color: viewModel.isBrightnessPass ? .green : .red)
                }
                .padding(.top, 40)
                
                Spacer()
                
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
            
            if viewModel.isLoading {
                LoadingCompView()
            }
        }
        .onReceive(viewModel.$result) { result in
            if let result = result {
                photoFlowViewModel.result = result
                photoFlowViewModel.step = .result
            }
        }
    }
    
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
