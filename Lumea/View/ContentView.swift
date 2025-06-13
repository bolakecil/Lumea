import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PhotoFlowViewModel()

    var body: some View {
        switch viewModel.step {
        case .start:
            StartView() // { viewModel.proceedToGuide() }
        case .guide:
            GuideView() // { viewModel.step = .capture }
        case .capture:
            // CaptureView(onPhotoTaken: viewModel.takePhoto)
            CaptureView()
        case .result:
            // ResultView(result: viewModel.result!, onReset: viewModel.resetFlow)
            ResultView()
        }
    }
}
