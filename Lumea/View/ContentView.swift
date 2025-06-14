import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PhotoFlowViewModel()
    
    var body: some View {
        switch viewModel.step {
        case .start:
            StartView(onStart: viewModel.proceedToGuide) // { viewModel.proceedToGuide() }
        case .guide:
            GuideView(onStartCapture: {viewModel.step = .capture}) // { viewModel.step = .capture }
        case .capture:
            // CaptureView(onPhotoTaken: viewModel.takePhoto)
            CaptureView()
        case .result:
            // ResultView(result: viewModel.result!, onReset: viewModel.resetFlow)
            ResultView()
        }
    }
}
