//
//  ContentView.swift
//  CropViewControllerSwiftUIExample
//
//  Created by KENJI WADA on 2020/07/25.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    enum SheetType {
        case imagePick
        case imageCrop
        case share
    }
    
    @State private var currentSheet: SheetType = .imagePick
    @State private var actionSheetIsPresented = false
    @State private var sheetIsPresented = false
    
    @State private var originalImage: UIImage?
    @State private var image: UIImage?
    @State private var croppingStyle = CropViewCroppingStyle.default
    @State private var croppedRect = CGRect.zero
    @State private var croppedAngle = 0
    
    var body: some View {
        NavigationView {
            VStack {
                if image == nil {
                    Text("Tap '+' to choose a photo.")
                        .foregroundColor(Color(UIColor.systemBlue))
                } else {
                    GeometryReader { geometry in
                        Image(uiImage: self.image!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width,
                               height: geometry.size.width)
                            .onTapGesture {
                                self.didTapImageView()
                            }
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("CropViewController", comment: "")), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.sharePhoto()
            }) {
                Image(systemName: "square.and.arrow.up")
            }, trailing: Button(action: {
                self.actionSheetIsPresented.toggle()
            }) {
                Image(systemName: "plus")
            })
        }
        .actionSheet(isPresented: $actionSheetIsPresented) {
            ActionSheet(title: Text(""), message: nil, buttons: [
                .default(Text("Crop Image"), action: {
                    self.croppingStyle = .default
                    self.currentSheet = .imagePick
                    self.sheetIsPresented = true
                }),
                .default(Text("Make Profile Picture"), action: {
                    self.croppingStyle = .circular
                    self.currentSheet = .imagePick
                    self.sheetIsPresented = true
                })
            ])
        }
        .sheet(isPresented: $sheetIsPresented) {
            if (self.currentSheet == .imagePick) {
                ImagePickerView(croppingStyle: self.croppingStyle, sourceType: .photoLibrary, onCanceled: {
                    // on cancel
                }) { (image) in
                    self.originalImage = image
                    self.currentSheet = .imageCrop
                    
                    // Wait for 1 second as the screen cannot be closed by `dismiss()`
                    DispatchQueue.main.asyncAfter(wallDeadline: .now() + .milliseconds(1000)) {
                        self.currentSheet = .imageCrop
                        self.sheetIsPresented = true
                    }
                }
            } else if (self.currentSheet == .imageCrop) {
                ImageCropView(croppingStyle: self.croppingStyle, originalImage: self.originalImage!, onCanceled: {
                    // on cancel
                }) { (image, cropRect, angle) in
                    // on success
                    self.image = image
                }
            } else if (self.currentSheet == .share) {
                ShareActivityView(image: self.image!, onCanceled: {
                    // on cancel
                }) {
                    // on success
                }
            }
        }
    }
    
    internal func sharePhoto() {
        guard let _ = image else {
            return
        }
        self.currentSheet = .share
        self.sheetIsPresented = true
    }
    
    internal func didTapImageView() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
