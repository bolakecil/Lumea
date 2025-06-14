import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: .all)
            VStack{
                Image("shade")
                    .resizable()
                    .rotationEffect(.degrees(90))
                    .frame(width: 650, height: 450)
                Text("Find your perfect Makeup Shade")
                    .font(.bethany(size: 35))
                    .padding(.top, 40)
                Text("Get personalized shade recommendations that blend seamlessly with your unique skin tone and undertone")
                    .font(.jakarta(size: 17))
                    .padding(.top, 10)
                    .padding(.horizontal, 125)
                    .multilineTextAlignment(.center)
                Button(action: {
                    print("Button tapped")
                }) {
                    Text("Get Started")
                        .font(.jakarta(size: 18))
                        .foregroundColor(.white)
                        .frame(width: 200, height: 70)
                        .background(Color.secondary)
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
