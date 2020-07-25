//
//  ShareActivityView.swift
//  CropViewControllerSwiftUIExample
//
//  Created by KENJI WADA on 2020/07/25.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

import SwiftUI

public struct ShareActivityView: UIViewControllerRepresentable {
    
    private let image: UIImage
    private let onCanceled: () -> Void
    private let onShared: () -> Void
    
    @Environment(\.presentationMode) private var presentationMode

    public init(image: UIImage, onCanceled: @escaping () -> Void, success onShared: @escaping () -> Void) {
        self.image = image
        self.onCanceled = onCanceled
        self.onShared = onShared
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activityType, completed, returnedItems, error) in
            if !completed {
                self.onCanceled()
                return
            }
            self.onShared()
        }
//        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem!
        return activityController
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
