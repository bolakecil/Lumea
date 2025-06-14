import SwiftUI

struct ResultView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Your Skintone: Light")
                    .font(.bethany(size: 28))
                    .padding(.bottom, 20)
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary)
                        .frame(width: 55, height: 55)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    Text("Your skin falls in the light category not too fair, but not deep either. It’s a common tone with a balanced warmth and slight golden hue.")
                        .padding(.leading, 30)
                }
                
                Text("Your Undertone: Warm")
                    .font(.bethany(size: 28))
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                Text("Warm undertone skin has golden, yellow, or peachy hues that give a naturally sun-kissed look and pairs best with warm colors and golden-based makeup shades.")
                
                Text("Your Shade Match")
                    .font(.bethany(size: 28))
                    .padding(.top, 50)
                    .padding(.bottom, 20)

                    
            }
            .padding(.horizontal, 85)
        }
    }
}

#Preview {
    ResultView()
}
