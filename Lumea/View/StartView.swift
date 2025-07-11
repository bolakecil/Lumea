import SwiftUI

struct StartView: View {
    var onStart: () -> Void = { }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: .all)
            VStack{
                Image("shade")
                    .resizable()
                    .scaledToFit()
                    .rotationEffect(.degrees(90))
                    .frame(width: 650, height: 450)
                Text("Discover Shade That May Suit You!")
                    .font(.bethany(size: 35))
                    .padding(.top, 40)
                Text("Get personalized shade recommendations that blend seamlessly with your unique skin tone and undertone")
                    .font(.jakarta(size: 17))
                    .padding(.top, 10)
                    .padding(.horizontal, 125)
                    .multilineTextAlignment(.center)
                Button(action: {
                    print("Button tapped")
                    onStart()
                }) {
                    Text("Get Started")
                        .font(.jakarta(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 70)
                        .background(Color.second)
                        .cornerRadius(20)
                }
                .padding(.top, 50)
            }
            .padding(.horizontal, 50)
        }
    }
}

#Preview {
    StartView()
}
