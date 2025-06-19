import SwiftUI
struct GuideView: View {
    let onStartCapture: () -> Void
    var body: some View {
        VStack(spacing: 60) {
            Spacer()
            
            Image("face 1")
                .resizable()
                .frame(width: 282, height: 306)
            
            VStack (spacing:12){
                Text("Let's Get You Ready to Scan")
                    .font(.bethany(size: 35))

                Text("Follow these tips to scan your skin more accurately.")
                    .font(.jakarta(size: 17))

            }
            
            
            HStack(spacing: 16) {
                VStack (spacing:20){
                    Image("face 2")
                        .resizable()
                        .frame(width: 80, height: 85)
                    Text("1. Keep face inside circle")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                }
                .frame(width: 160, height: 200)
                .background(Color.first)
                .cornerRadius(20)
                
                
                VStack (spacing:20){
                    Image("no makeup")
                        .resizable()
                        .frame(width: 80, height: 85)
                    
                    VStack (){
                        Text("2. Remove")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("makeup")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                }
                .frame(width: 160, height: 200)
                .background(Color.first)
                .cornerRadius(20)
                
                
                VStack (spacing:30){
                    Image("look straight")
                        .resizable()
                        .frame(width: 100, height: 70)
                    
                    VStack (){
                        Text("3. Look straight")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("to the screen")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 160, height: 200)
                .background(Color.first)
                .cornerRadius(20)
                
                
                
                VStack (spacing:20){
                    Image("lighting")
                        .resizable()
                        .frame(width: 70, height: 80)
                    
                    VStack (){
                        Text("4. Good")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("lighting")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 160, height: 200)
                .background(Color.first)
                .cornerRadius(20)
        
            }


            // Start Scan Button
            Button(action: {
                onStartCapture()
            }) {
                Text("Start Scan")
                    .font(.jakarta(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 70)
                    .background(Color.second)
                    .cornerRadius(20)
            }
            Spacer()

        }
        .frame(width:900, height:1200)
        .background(Color("background").edgesIgnoringSafeArea(.all))

    }

}

#Preview {
    GuideView(onStartCapture: {
        print("Start capture tapped")
    })
}
