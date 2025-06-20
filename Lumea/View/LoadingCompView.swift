import SwiftUI

struct LoadingCompView: View {
    @State private var angle: Double = 0
    @State private var appearedBalls: Set<Int> = []
    
    let ballCount = 18
    let ellipseWidth: CGFloat = 480
    let ellipseHeight: CGFloat = 680
    let ballSize: CGFloat = 12
    let animationDuration = 2.0
    let delayBetweenBalls = 0.15
    
    var body: some View {
        ZStack {
            ForEach(0..<ballCount, id: \.self) { i in
                let degree = angle + (Double(i) / Double(ballCount)) * 360
                let radian = Angle(degrees: degree).radians
                let x = cos(radian) * (ellipseWidth / 2)
                let y = sin(radian) * (ellipseHeight / 2)
                
                let relativeY = sin(radian)
                let scale = 0.6 + 0.4 * (1 + relativeY)
                let opacity = 0.3 + 0.7 * (1 + relativeY)
                
                Circle()
                    .frame(width: ballSize, height: ballSize)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(appearedBalls.contains(i) ? opacity : 0)
                    .offset(x: x, y: y)
                    .animation(.easeOut(duration: 0.5), value: appearedBalls)
            }
        }
        .frame(width: ellipseWidth, height: ellipseHeight)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
                angle += 360 / (animationDuration * 60)
            }
            
            for i in 0..<ballCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + (Double(i) * delayBetweenBalls)) {
                    appearedBalls.insert(i)
                }
            }
        }
    }
}
