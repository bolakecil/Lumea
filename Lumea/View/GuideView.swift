import SwiftUI

struct GuideView: View {
    
    var onStartCapture: () -> Void = { }
    
    var body: some View {
        Text("GuideView")
        
        Button("Start Capture") {
            print(">>> Start Capture <<<")
            onStartCapture()
        }
    }
}

