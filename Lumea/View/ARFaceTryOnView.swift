//import SwiftUI
//import ARKit
//
//struct ARFaceTryOnView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel: ARFaceViewModel
//    @StateObject private var sessionViewModel = ARSessionViewModel()
//    
//    init(shades: [ShadeOption]) {
//        _viewModel = StateObject(wrappedValue: ARFaceViewModel(shades: shades))
//    }
//    
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            Group {
//                switch viewModel.arState {
//                case .loading:
//                    LoadingView()
//                case .ready:
//                    ARContentView(
//                        selectedShade: $viewModel.selectedShade,
//                        sessionViewModel: sessionViewModel
//                    )
//                case .error(let message):
//                    ErrorView(message: message) {
//                        viewModel.resetARState()
//                    }
//                case .unsupported:
//                    UnsupportedDeviceView()
//                }
//            }
//            
//            VStack {
//                if case .limited = sessionViewModel.trackingState {
//                    TrackingStatusView(message: sessionViewModel.trackingStateMessage)
//                        .padding(.top, 100)
//                }
//
//                Spacer()
//                
//                ShadeSelectionView(
//                    selectedShade: $viewModel.selectedShade,
//                    shades: viewModel.availableShades,
//                    onShadeSelected: viewModel.selectShade
//                )
//            }
//
//            BackButton {
//                dismiss()
//            }
//        }
//        .ignoresSafeArea()
//        .navigationBarBackButtonHidden(true)
//    }
//}
//
//// MARK: - AR Content View
//struct ARContentView: View {
//    @Binding var selectedShade: ShadeOption
//    let sessionViewModel: ARSessionViewModel
//
//    var body: some View {
//        FaceMeshARViewRepresentable(
//            selectedShade: $selectedShade,
//            sessionViewModel: sessionViewModel
//        )
//    }
//}
//
//// MARK: - Bottom Shade Picker
//struct ShadeSelectionView: View {
//    @Binding var selectedShade: ShadeOption
//    let shades: [ShadeOption]
//    let onShadeSelected: (ShadeOption) -> Void
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            if !shades.isEmpty {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15) {
//                        ForEach(shades) { shade in
//                            ShadeOptionButton(
//                                shade: shade,
//                                isSelected: selectedShade.id == shade.id,
//                                onTap: { onShadeSelected(shade) }
//                            )
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//
//            Text(selectedShade.name)
//                .font(.headline)
//                .foregroundColor(.primary)
//                .padding(.bottom, 10)
//        }
//        .padding()
//        .background(Color.white.opacity(0.95))
//        .cornerRadius(20, corners: [.topLeft, .topRight])
//    }
//}
//
//// MARK: - Single Shade Button
//struct ShadeOptionButton: View {
//    let shade: ShadeOption
//    let isSelected: Bool
//    let onTap: () -> Void
//
//    var body: some View {
//        VStack(spacing: 5) {
//            Button(action: onTap) {
//                Image(shade.imageName)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: isSelected ? 80 : 60)
//                    .shadow(radius: isSelected ? 5 : 0)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
//                    )
//                    .animation(.easeInOut(duration: 0.2), value: isSelected)
//            }
//
//            Text(shade.name)
//                .font(.system(size: 14))
//                .foregroundColor(.primary)
//                .lineLimit(2)
//                .multilineTextAlignment(.center)
//        }
//    }
//}
//
//// MARK: - Back Button
//struct BackButton: View {
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.primary)
//                .font(.title2)
//                .padding()
//                .background(Color.white.opacity(0.8))
//                .clipShape(Circle())
//        }
//        .padding(.top, 50)
//        .padding(.leading, 20)
//    }
//}
//
//// MARK: - UI Overlays
//struct LoadingView: View {
//    var body: some View {
//        ZStack {
//            Color.black
//            VStack {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                    .scaleEffect(1.5)
//                Text("Initializing AR...")
//                    .foregroundColor(.white)
//                    .font(.headline)
//                    .padding(.top)
//            }
//        }
//    }
//}
//
//struct ErrorView: View {
//    let message: String
//    let onRetry: () -> Void
//
//    var body: some View {
//        ZStack {
//            Color.black
//            VStack(spacing: 20) {
//                Image(systemName: "exclamationmark.triangle")
//                    .font(.system(size: 60))
//                    .foregroundColor(.orange)
//
//                Text("AR Error")
//                    .font(.title2)
//                    .foregroundColor(.white)
//
//                Text(message)
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//
//                Button("Try Again", action: onRetry)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//        }
//    }
//}
//
//struct UnsupportedDeviceView: View {
//    var body: some View {
//        ZStack {
//            Color.black
//            VStack(spacing: 20) {
//                Image(systemName: "face.dashed")
//                    .font(.system(size: 80))
//                    .foregroundColor(.white)
//
//                Text("AR Not Supported")
//                    .font(.title2)
//                    .foregroundColor(.white)
//
//                Text("Face tracking is not supported on this device.")
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.horizontal)
//            }
//        }
//    }
//}
//
//struct TrackingStatusView: View {
//    let message: String
//
//    var body: some View {
//        Text(message)
//            .font(.caption)
//            .foregroundColor(.white)
//            .padding(.horizontal, 16)
//            .padding(.vertical, 8)
//            .background(Color.orange.opacity(0.8))
//            .cornerRadius(20)
//            .padding(.horizontal)
//    }
//}
//
//// MARK: - Rounded Corners Extension
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: corners,
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//        return Path(path.cgPath)
//    }
//}


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
//        faceGeom.firstMaterial?.lightingModel = .physicallyBased
//        faceGeom.firstMaterial?.diffuse.contents = parent.selectedColor
//        faceGeom.firstMaterial?.transparency = 0.1 // add this to reduce opacity
        
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


