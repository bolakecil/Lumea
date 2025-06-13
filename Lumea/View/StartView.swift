import SwiftUI

struct StartView: View {
    var body: some View {
        VStack{
            Image("shade")
                .resizable()
                .rotationEffect(.degrees(90))
                .frame(width: 600, height: 400)
            Text("Find your perfect Makeup Shade")
                .font(.bethany(size: 30))
                .padding(.top, 50)
            Text("Get personalized shade recommendations that blend seamlessly with your unique skin tone and undertone")
                .font(.bethany(size: 23))
                .padding(.top, 20)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    StartView()
}
