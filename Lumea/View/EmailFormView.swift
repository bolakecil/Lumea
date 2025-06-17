//
//  EmailFormView.swift
//  Lumea
//
//  Created by Nicholas  on 17/06/25.
//

import SwiftUI
import MessageUI

struct EmailFormView: View {
    @State var email: String = ""
    @State private var capturedImage: UIImage?
    @Environment(\.dismiss) var dismiss

    let result: PhotoAnalysisResult
    
    let viewModel: PhotoFlowViewModel
    
    var body: some View{
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                            dismiss()
                        }

            VStack(alignment: .center, spacing: 20) {
                Text("Send Screenshot via Email")
                    .font(.headline)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(width: 250)

                Button("Send Email") {
                    let screenSize = UIScreen.main.bounds.size
                    let view = ResultSnapView(result: result, viewModel: viewModel).frame(width: screenSize.width, height: screenSize.height)

                    if let image = captureView(view: view, size: screenSize) {
                        let opaqueImage = makeOpaqueImage(image)
                        capturedImage = opaqueImage
                        sendEmailToServer(email: email, image: opaqueImage)
                        UIImageWriteToSavedPhotosAlbum(opaqueImage, nil, nil, nil)
                    }
                }
                .padding()
                .frame(width: 200)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
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
    
    EmailFormView(result: sampleResult, viewModel: PhotoFlowViewModel())
}
