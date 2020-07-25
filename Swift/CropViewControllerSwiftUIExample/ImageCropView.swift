//
//  ImageCropView.swift
//  CropViewControllerSwiftUIExample
//
//  Created by KENJI WADA on 2020/07/25.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

import SwiftUI

public struct ImageCropView: UIViewControllerRepresentable {
    
    private var croppingStyle = CropViewCroppingStyle.default
    private let originalImage: UIImage
    private let onCanceled: () -> Void
    private let onImageCropped: (UIImage,CGRect,Int) -> Void
    
    @Environment(\.presentationMode) private var presentationMode

    public init(croppingStyle: CropViewCroppingStyle, originalImage: UIImage, onCanceled: @escaping () -> Void, success onImageCropped: @escaping (UIImage,CGRect,Int) -> Void) {
        self.croppingStyle = croppingStyle
        self.originalImage = originalImage
        self.onCanceled = onCanceled
        self.onImageCropped = onImageCropped
    }

    public func makeUIViewController(context: Context) -> CropViewController {
        let cropController = CropViewController(croppingStyle: croppingStyle, image: originalImage)
//        cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = context.coordinator

        // Uncomment this if you wish to provide extra instructions via a title label
        //cropController.title = "Crop Image"
    
        // -- Uncomment these if you want to test out restoring to a previous crop setting --
        //cropController.angle = 90 // The initial angle in which the image will be rotated
        //cropController.imageCropFrame = CGRect(x: 0, y: 0, width: 2848, height: 4288) //The initial frame that the crop controller will have visible.
    
        // -- Uncomment the following lines of code to test out the aspect ratio features --
        //cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        //cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized away from it
        //cropController.resetAspectRatioEnabled = false // When tapping 'reset', the aspect ratio will NOT be reset back to default
        //cropController.aspectRatioPickerButtonHidden = true
    
        // -- Uncomment this line of code to place the toolbar at the top of the view controller --
        //cropController.toolbarPosition = .top
    
        //cropController.rotateButtonsHidden = true
        //cropController.rotateClockwiseButtonHidden = true
    
        //cropController.doneButtonTitle = "Title"
        //cropController.cancelButtonTitle = "Title"
        
        //cropController.toolbar.doneButtonHidden = true
        //cropController.toolbar.cancelButtonHidden = true
        //cropController.toolbar.clampButtonHidden = true
        
        return cropController
    }

    public func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onCanceled: self.onCanceled,
            onImageCropped: self.onImageCropped
        )
    }

    final public class Coordinator: NSObject, CropViewControllerDelegate {

        private let onDismiss: () -> Void
        private let onImageCropped: (UIImage,CGRect,Int) -> Void
        private let onCanceled: () -> Void

        init(onDismiss: @escaping () -> Void, onCanceled: @escaping () -> Void, onImageCropped: @escaping (UIImage,CGRect,Int) -> Void) {
            self.onDismiss = onDismiss
            self.onImageCropped = onImageCropped
            self.onCanceled = onCanceled
        }

        public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

            self.onImageCropped(image, cropRect, angle)
            self.onDismiss()
        }
        
        public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            
            self.onImageCropped(image, cropRect, angle)
            self.onDismiss()
        }
        
        public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            
            self.onCanceled()
            self.onDismiss()
        }
    }
}
