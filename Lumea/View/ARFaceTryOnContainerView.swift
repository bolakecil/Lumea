//
//  ARFaceTryOnContainerView.swift
//  Lumea
//
//  Created by Jessica Lynn on 17/06/25.
//


import SwiftUI

struct ARFaceTryOnContainerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedColor: UIColor = .white
    @State private var selectedShadeId: UUID? // Track selected shade

    let shadeOptions: [ShadeOption]

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 0) {
                ARFaceTryOnView(selectedColor: $selectedColor)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxHeight: .infinity)

                // Shade Picker
                HStack {
                    ForEach(shadeOptions, id: \.id) { shade in
                        Spacer()
                        Button(action: {
                            print("Tapped shade: \(shade.name)")
                            selectedShadeId = shade.id
                            if let color = UIColor(hex: shade.hex) {
                                selectedColor = color
                            } else {
                                print("❌ Invalid hex: \(shade.hex)")
                            }
                        }) {
                            VStack {
                                Image(shade.imageName)
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                                Text(shade.name)
                                    .font(.jakarta(size: 13))
                                    .foregroundStyle(.black)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(shade.id == selectedShadeId ? Color.secondary : Color.clear, lineWidth: 2)
                            )
                        }
                        Spacer()
                    }
                }
                .padding(.vertical, 20)
                .background(Color.background)
            }

            // Dismiss button
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.backward.circle.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
            }
        }
    }
}
