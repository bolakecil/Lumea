import SwiftUI

struct ResultView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 85, height: 85)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.bottom, 15)
                    Text("You may be a:")
                        .font(.jakarta(size: 17))
                        .padding(.bottom, 10)
                    Text("Light Warm")
                        .font(.bethany(size: 28))
                        .padding(.bottom, 20)
                    Text("""
                    Light Warm skintone suits **earthy tones**, **gold jewelry**, and **peachy makeup**.  
                    **Avoid** **cool tones** and **pink-based foundations**, they can wash you out!
                    """)
//                        .font(.jakarta(size: 17))
                    //hee hee hee cant be formatted otherwise
                    .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading){
                        Text("Suggested Shades")
                            .font(.bethany(size: 28))
                            .padding(.bottom, 20)
                        VStack(spacing: 0) {
                            HStack() {
                                Spacer()
                                VStack {
                                    Image("shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text("Warm Mable")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                                Rectangle()
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity) // let it stretch
                                Spacer()
                                VStack {
                                    Image("shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text("Warm Ivory")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                                Rectangle()
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity) // let it stretch
                                Spacer()
                                VStack {
                                    Image("shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text("Warm Beige")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                            }
                            .frame(height: 160)

                            Rectangle()
                                .frame(height: 1)

                            Button(action: {
                                print("Try Me Now tapped")
                            }) {
                                Text("Try Me Now!")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundStyle(Color.white)
                                    .background(Color.first)
                            }
                            .buttonStyle(.plain)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )

                        
                        
                        Text("You may want to try these too!")
                            .font(.bethany(size: 28))
                            .padding(.bottom, 20)
                            .padding(.top, 60)
                        HStack{
                            Spacer()
                            VStack{
                                Image("shade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                Text("Gold Jewelry")
                                    .font(.jakarta(size: 17))
                            }
                            Spacer()
                            Rectangle()
                                .frame(width: 1, height: 160)
                            Spacer()
                            VStack{
                                Image("shade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                Text("Brown Shirt")
                                    .font(.jakarta(size: 17))
                            }
                            Spacer()
                            Rectangle()
                                .frame(width: 1, height: 160)
                            Spacer()
                            VStack{
                                Image("shade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                Text("Brown Hair")
                                    .font(.jakarta(size: 17))
                            }
                            Spacer()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        
                        HStack{
                            Button(action: {
                                print("Button tapped")
                                
                            }) {
                                Text("Try Again")
                                    .font(.jakarta(size: 18))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black, lineWidth: 1)
                                    )
                            }
                            .padding(.trailing, 5)
                            Spacer()
                            Button(action: {
                                print("Button tapped")
                                
                            }) {
                                Text("Share Result")
                                    .font(.jakarta(size: 18))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 70)
                                    .background(Color.second)
                                    .cornerRadius(20)
                            }
                            .padding(.leading, 5)
                        }
                        .padding(.top, 70)
                    }
                    .padding(.top, 50)
                }
                .padding(.horizontal, 85)
            }
        }
    }
}

#Preview {
    ResultView()
}
