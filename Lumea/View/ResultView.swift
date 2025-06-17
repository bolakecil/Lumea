import SwiftUI
import MessageUI

struct ResultView: View {
    @State private var isShowingEmailForm = false
    @State var email: String = ""
    @State private var capturedImage: UIImage?
    @State private var emailSent = false
    @State private var didTapSend: Bool = false
    @State private var isShowingTryOn = false
    @State private var selectedShadeColor: UIColor = .white


    
    let result: PhotoAnalysisResult
    
    let viewModel: PhotoFlowViewModel

    var assetInfo: VisualAssets {
        viewModel.resolvedAssets(for: result)
    }

    var skinColor: Color {
        Color(hex: result.skintone.label) ?? .gray
    }

    var matchingShades: [String] {
        result.skintone.shadeRecommendations
    }
    
//    var shadeOptions: [ShadeOption] {
//        matchingShades.map {
//            ShadeOption(name: $0, hex: $0, imageName: $0) // assuming imageName = hex
//        }
//    }
    
    var shadeOptions: [ShadeOption] {
        ShadeMapper.getShadeMatches(for: result.undertone.type.rawValue, skintoneGroup: result.skintoneGroup).map {
            ShadeOption(name: $0.name, hex: $0.hex, imageName: $0.name)
        }
    }



    var undertoneLabel: String {
        result.undertone.type.rawValue
    }
    
    var skinToneDescription: AttributedString {
        let markdownText = SkinToneDescriptions.getDescription(
            for: result.skintoneGroup,
            undertone: result.undertone.type.rawValue
        )
        
        do {
            return try AttributedString(markdown: markdownText)
        } catch {
            return AttributedString("Unable to load description")
        }
    }
    
    var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return !trimmed.isEmpty && trimmed.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea(edges: .all)
                VStack {
                    Circle()
                        .fill(skinColor)
                        .frame(width: 85, height: 85)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.bottom, 15)
                    Text("You may be a:")
                        .font(.jakarta(size: 17))
                        .padding(.bottom, 10)
                    Text("\(result.skintoneGroup) \(undertoneLabel.capitalized)")
                        .font(.bethany(size: 28))
                        .padding(.bottom, 20)
                    Text(skinToneDescription)
                        .multilineTextAlignment(.center)
//                        .font(.jakarta(size: 17))
                    //hee hee hee cant be formatted otherwise
                    
                    VStack(alignment: .leading){
                        Text("Suggested Shades")
                            .font(.bethany(size: 28))
                            .padding(.bottom, 20)
                        VStack(spacing: 0) {
                            HStack() {
                                Spacer()
                                VStack {
                                    Image(assetInfo.shadeRecommendations.count > 0 ? assetInfo.shadeRecommendations[0] : "shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text(assetInfo.shadeRecommendations.count > 0 ? assetInfo.shadeRecommendations[0] : "Shade 1")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                                Rectangle()
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity)
                                Spacer()
                                VStack {
                                    Image(assetInfo.shadeRecommendations.count > 1 ? assetInfo.shadeRecommendations[1] : "shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text(assetInfo.shadeRecommendations.count > 1 ? assetInfo.shadeRecommendations[1] : "Shade 2")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                                Rectangle()
                                    .frame(width: 1)
                                    .frame(maxHeight: .infinity)
                                Spacer()
                                VStack {
                                    Image(assetInfo.shadeRecommendations.count > 2 ? assetInfo.shadeRecommendations[2] : "shade")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 100)
                                    Text(assetInfo.shadeRecommendations.count > 2 ? assetInfo.shadeRecommendations[2] : "Shade 3")
                                        .font(.jakarta(size: 17))
                                }
                                Spacer()
                            }
                            .frame(height: 160)

                            Rectangle()
                                .frame(height: 1)

                            Button(action: {
                                if let hex = matchingShades.first,
                                   let color = UIColor(hex: hex) {
                                    selectedShadeColor = color
                                }
                                withAnimation {
                                    isShowingTryOn = true
                                }
                            }) {
                                Text("Try Me Now!")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundStyle(Color.white)
                            }
                            .background(
                                RoundedCorners(topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 10)
                                    .fill(Color.first)
                            )
                            .buttonStyle(.plain)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
//                        NavigationLink(
//                            destination: ARFaceTryOnView(shades: shadeOptions),
//                            isActive: $isShowingTryOn
//                        ) {
//                            EmptyView()
//                        }
//                        .hidden()
                        .fullScreenCover(isPresented: $isShowingTryOn) {
                            ARFaceTryOnContainerView(shadeOptions: shadeOptions)
                        }

                        
                        Text("You may want to try these too!")
                            .font(.bethany(size: 28))
                            .padding(.bottom, 20)
                            .padding(.top, 60)
                        HStack {
                            Spacer()
                            VStack {
                                Image(assetInfo.accessoryAsset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text("Accessory")
                                    .font(.jakarta(size: 17))
                                    .padding(.top, 3)
                            }
                            Spacer()
                            Rectangle().frame(width: 1).frame(height: 160)
                            Spacer()
                            VStack {
                                Image(assetInfo.shirtAsset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text("Shirt Color")
                                    .font(.jakarta(size: 17))
                                    .padding(.top, 3)
                            }
                            Spacer()
                            Rectangle().frame(width: 1).frame(height: 160)
                            Spacer()
                            VStack {
                                Image(assetInfo.hairAsset)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 90)
                                Text("Hair Color")
                                    .font(.jakarta(size: 17))
                                    .padding(.top, 3)
                            }
                            Spacer()
                        }

                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        
                        HStack{
                            Button(action: {
                                viewModel.resetFlow()
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
                                isShowingEmailForm = true
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
                
                if isShowingEmailForm {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isShowingEmailForm = false
                            }

                        VStack(alignment: .center, spacing: 20) {
                            Text("Send Screenshot via Email")
                                .font(.headline)

                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(width: 250)
                                .disabled(emailSent)
                            
                            if didTapSend && !isEmailValid {
                                Text("Please enter a valid email address.")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }


                            Button(action: {
                                didTapSend = true
                                
                                if isEmailValid {
                                    let screenSize = UIScreen.main.bounds.size
                                    let view = ResultSnapView(result: result, viewModel: viewModel)
                                        .frame(width: screenSize.width, height: screenSize.height)

                                    if let image = captureView(view: view, size: screenSize) {
                                        let opaqueImage = makeOpaqueImage(image)
                                        sendEmailToServer(email: email, image: opaqueImage)
                                        emailSent = true
                                    }
                                }
                                
                            }) {
                                if emailSent {
                                    Label("Email Sent!", systemImage: "checkmark.circle.fill")
                                        .frame(width: 200)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                } else {
                                    Text("Send Email")
                                        .frame(width: 200)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.second)
                                        .cornerRadius(10)
                                }
                            }
                            .disabled(emailSent)
                        }
                        .padding()
                        .frame(width: 300)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                    .transition(.opacity.combined(with: .scale))
                    .zIndex(1)
                }


            }
        }
    }
    
    func sendEmailToServer(email: String, image: UIImage) {
        guard let url = URL(string: "http://10.60.62.165:3000/sendEmail") else {
            print("Invalid server URL")
            return
        }
        
        // Convert image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG")
            return
        }
        
        // Create multipart form boundary
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Build multipart body
        var body = Data()
        
        // Add email field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"to\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(email)\r\n".data(using: .utf8)!)
        
        // Add image field
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"screenshot.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // End boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Server responded with status: \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
}

#Preview {
    let sampleResult = PhotoAnalysisResult(
        undertone: UndertoneResult(
            type: .cool,
            accessoryColors: [],
            shirtColors: [],
            hairColors: []
        ),
        skintone: SkintoneResult(
            label: "#9D7A54",
            shadeRecommendations: [] // This will be populated by ShadeMapper
        ),
        skintoneGroup: "Medium",
        rawImage: UIImage()
    )

    ResultView(result: sampleResult, viewModel: PhotoFlowViewModel())
}
