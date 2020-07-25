//
//  ImagePickerView.swift
//  CropViewControllerSwiftUIExample
//
//  Created by KENJI WADA on 2020/07/25.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {

    private var croppingStyle = CropViewCroppingStyle.default
    private let sourceType: UIImagePickerController.SourceType
    private let onCanceled: () -> Void
    private let onImagePicked: (UIImage) -> Void
    
    @Environment(\.presentationMode) private var presentationMode

    public init(croppingStyle: CropViewCroppingStyle, sourceType: UIImagePickerController.SourceType, onCanceled: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
        self.croppingStyle = croppingStyle
        self.sourceType = sourceType
        self.onCanceled = onCanceled
        self.onImagePicked = onImagePicked
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        if croppingStyle == .circular {
            imagePicker.modalPresentationStyle = .popover
//        imagePicker.popoverPresentationController?.barButtonItem = (sender as! UIBarButtonItem)
            imagePicker.preferredContentSize = CGSize(width: 320, height: 568)
        }
        imagePicker.sourceType = self.sourceType
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onCanceled: self.onCanceled,
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onCanceled: () -> Void
        private let onImagePicked: (UIImage) -> Void

        init(onDismiss: @escaping () -> Void, onCanceled: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onCanceled = onCanceled
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }
        
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onCanceled()
            self.onDismiss()
        }
    }
}
