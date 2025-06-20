import SwiftUI
import ARKit
import SceneKit

struct ARFaceTryOnView: UIViewRepresentable {
  @Binding var selectedColor: UIColor
  
  func makeUIView(context: Context) -> ARSCNView {
    let scnView = ARSCNView()
    scnView.delegate = context.coordinator
    scnView.session.run(ARFaceTrackingConfiguration())
    return scnView
  }

  func updateUIView(_ uiView: ARSCNView, context: Context) {
    // Coordinator will handle updating the material color
  }

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  class Coordinator: NSObject, ARSCNViewDelegate {
    var parent: ARFaceTryOnView
    var faceNode: SCNNode?

    init(_ parent: ARFaceTryOnView) {
      self.parent = parent
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
      guard let device = (renderer as? ARSCNView)?.device,
            let faceGeom = ARSCNFaceGeometry(device: device) else {
        return nil
      }
       
        faceGeom.firstMaterial?.lightingModel = .constant
        faceGeom.firstMaterial?.diffuse.contents = parent.selectedColor.withAlphaComponent(0.3)
        faceGeom.firstMaterial?.transparency = 0.4
        faceGeom.firstMaterial?.transparencyMode = .dualLayer


      let node = SCNNode(geometry: faceGeom)
      faceNode = node
      return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      guard let faceGeom = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor else { return }
      faceGeom.update(from: faceAnchor.geometry)
      faceGeom.firstMaterial?.diffuse.contents = parent.selectedColor
    }
  }
}


