//
//  ARTryOnState.swift
//  Lumea
//
//  Created by Jessica Lynn on 17/06/25.
//


import SwiftUI
import ARKit
import Combine

enum ARTryOnState: Equatable {
    case loading
    case ready
    case unsupported
    case error(String)
}

class ARFaceViewModel: ObservableObject {
    @Published var selectedShade: ShadeOption
    @Published var arState: ARTryOnState = .loading
    @Published var isARSupported: Bool = false
    
    private let shades: [ShadeOption]
    
    init(shades: [ShadeOption]) {
        self.shades = shades.isEmpty ? [ShadeOption.placeholder] : shades
        self.selectedShade = self.shades.first!
        checkARSupport()
    }
    
    func selectShade(_ shade: ShadeOption) {
        selectedShade = shade
    }
    
    func selectShade(hex: String) {
        if let shade = shades.first(where: { $0.hex == hex }) {
            selectedShade = shade
        } else {
            let tempShade = ShadeOption(name: "Custom", hex: hex, imageName: "default_swipe")
            selectedShade = tempShade
        }
    }
    
    var availableShades: [ShadeOption] {
        return shades
    }
    
    private func checkARSupport() {
        isARSupported = ARFaceTrackingConfiguration.isSupported
        arState = isARSupported ? .ready : .unsupported
    }
    
    func handleARError(_ error: Error) {
        arState = .error(error.localizedDescription)
    }
    
    func resetARState() {
        if isARSupported {
            arState = .ready
        }
    }
}

class ARSessionViewModel: ObservableObject {
    @Published var trackingState: ARCamera.TrackingState = .notAvailable
    @Published var isSessionRunning: Bool = false
    
    func updateTrackingState(_ state: ARCamera.TrackingState) {
        DispatchQueue.main.async {
            self.trackingState = state
        }
    }
    
    func updateSessionState(_ isRunning: Bool) {
        DispatchQueue.main.async {
            self.isSessionRunning = isRunning
        }
    }
    
    var trackingStateMessage: String {
        switch trackingState {
        case .normal:
            return "Tracking normally"
        case .notAvailable:
            return "Tracking unavailable"
        case .limited(let reason):
            switch reason {
            case .excessiveMotion:
                return "Move device more slowly"
            case .insufficientFeatures:
                return "Point device at a face"
            case .initializing:
                return "Initializing AR..."
            case .relocalizing:
                return "Recovering tracking..."
            @unknown default:
                return "Tracking limited"
            }
        }
    }
}
