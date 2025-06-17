//
//  ResultSnapVIew.swift
//  Lumea
//
//  Created by Nicholas  on 17/06/25.
//

import SwiftUI

struct ResultSnapView: View {
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
                        
                            
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        
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
                        
                    }
                    .padding(.top, 50)
                }
                .padding(.horizontal, 85)
            }
        }
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
    
    ResultSnapView(result: sampleResult, viewModel: PhotoFlowViewModel())
}

