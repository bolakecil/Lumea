//
//  ResultSnapViewModel.swift
//  Lumea
//
//  Created by Nicholas  on 17/06/25.
//

import SwiftUI
import UIKit

@MainActor
func captureView<Content: View>(view: Content, size: CGSize) -> UIImage? {
    let controller = UIHostingController(rootView: view)
    let view = controller.view

    let targetSize = CGSize(width: size.width, height: size.height)
    view?.bounds = CGRect(origin: .zero, size: targetSize)
    view?.backgroundColor = .clear

    let renderer = UIGraphicsImageRenderer(size: targetSize)

    return renderer.image { _ in
        view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
    }
}


func makeOpaqueImage(_ image: UIImage) -> UIImage {
    let format = UIGraphicsImageRendererFormat.default()
    format.opaque = true

    let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
    return renderer.image { _ in
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(origin: .zero, size: image.size)).fill()
        image.draw(at: .zero)
    }
}



