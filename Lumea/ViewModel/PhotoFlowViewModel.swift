//
//  PhotoFlowViewModel.swift
//  Lumea
//
//  Created by Jessica Lynn on 13/06/25.
//

import SwiftUI


class PhotoFlowViewModel: ObservableObject {
    enum Step {
        case start, guide, capture, result
    }

    @Published var step: Step = .start
    @Published var capturedImage: UIImage?
    @Published var result: PhotoAnalysisResult?

    private let model = try! modelAFAD25iter(configuration: .init())

    func proceedToGuide() {
        step = .guide
    }

    func takePhoto(_ image: UIImage) {
        self.capturedImage = image
        analyze(image)
    }

    private func analyze(_ image: UIImage) {
        // Convert to CVPixelBuffer and run ML
        // Update `result` and `step`
        step = .result
    }

    func resetFlow() {
        step = .start
        capturedImage = nil
        result = nil
    }
}
