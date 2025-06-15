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
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.background)
                                .frame(height: 160)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                            HStack{
                                Spacer()
                                VStack{
                                    Image("shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text("Warm Beige")
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
                                    Text("Warm Beige")
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
                                    Text("Warm Beige")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 50)
                    VStack(alignment: .leading){
                        Text("You may want to try these too!")
                            .font(.bethany(size: 28))
                            .padding(.bottom, 20)
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.background)
                                .frame(height: 160)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                )
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
                        }
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
                                    .background(Color.secondary)
                                    .cornerRadius(20)
                            }
                            .padding(.leading, 5)
                        }
                        .padding(.top, 70)
                    }
                    .padding(.vertical, 50)
                    
                }
                .padding(.horizontal, 85)
            }
        }
    }
}

#Preview {
    ResultView()
}
