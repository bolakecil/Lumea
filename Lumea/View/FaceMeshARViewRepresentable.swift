//
//  FaceMeshARViewRepresentable.swift
//  Lumea
//
//  Created by Jessica Lynn on 17/06/25.
//


import SwiftUI
import RealityKit
import ARKit
import SceneKit
import Foundation

struct FaceMeshARViewRepresentable: UIViewRepresentable {
    @Binding var selectedShade: ShadeOption
    let sessionViewModel: ARSessionViewModel

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config, options: [])

        let anchor = AnchorEntity(.face)
        arView.scene.anchors.append(anchor)
        context.coordinator.loadFaceMesh(into: anchor)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.updateShade(to: selectedShade.color)
    }

    class Coordinator {
        var faceModel: ModelEntity?

        func loadFaceMesh(into anchor: AnchorEntity) {
            guard let device = MTLCreateSystemDefaultDevice(),
                  let faceGeometry = ARSCNFaceGeometry(device: device) else { return }

            let mesh = MeshResource.generateSphere(radius: 0.1)
            let material = SimpleMaterial(color: .brown.withAlphaComponent(0.4), isMetallic: false)
            let model = ModelEntity(mesh: mesh, materials: [material])

            faceModel = model
            anchor.addChild(model)
        }

        func updateShade(to color: UIColor) {
            let material = SimpleMaterial(color: color.withAlphaComponent(0.4), isMetallic: false)
            faceModel?.model?.materials = [material]
        }
    }
}
