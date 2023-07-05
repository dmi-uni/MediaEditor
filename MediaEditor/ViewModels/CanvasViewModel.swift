//
//  CanvasViewModel.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI
import PhotosUI
import PencilKit

@MainActor
class CanvasViewModel: ObservableObject {
    @Published var data: Data = Data(count: 0)
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    
    // For editing mode picker
//    @Published var selectedMode = "Draw"
//    @Published var editModes = ["Draw", "Text"]
    
    @Published var textBoxes: [TextBox] = []
    @Published var isAddingTextBox = false
    @Published var currentIndex: Int  = 0
    @Published var rect: CGRect = .zero
    
    //Alert
    @Published var showAlert = false
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                self.data = data
            }
        } catch {
            print(error.localizedDescription)
            data = Data(count: 0)
        }
    }
    
    // Closing canvas
    func cancelImageEditing() {
        data = Data(count: 0)
        canvas = PKCanvasView()
        textBoxes.removeAll()
//        selectedMode = "Draw"
    }
    
    // Closing text editing view
    func cancelTextBoxEditing() {
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            isAddingTextBox = false
        }
        
        if !textBoxes[currentIndex].isAdded {
            textBoxes.removeLast()
            currentIndex = textBoxes.count - 1
            print(currentIndex)
        }
    }
    
    func saveTextBox() {
        textBoxes[currentIndex].isAdded = true
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        canvas.becomeFirstResponder()
        
        withAnimation {
            isAddingTextBox = false
        }
        
        print(currentIndex)
    }
    
    func saveImage() {
        // generating image from canvas with textboxes
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        
        canvas.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let SwiftUIView = ZStack {
            ForEach(textBoxes) {[self] box in
                Text(textBoxes[currentIndex].id == box.id && isAddingTextBox ? "" : box.text)
                    .font(.system(.title, weight: textBoxes[currentIndex].isBold ? .bold : .regular))
                    .foregroundColor(box.textColor)
                    .offset(x: box.position.width, y: box.position.height)
            }
        }

        let controller = UIHostingController(rootView: SwiftUIView).view!
        controller.frame = rect

        controller.backgroundColor = .clear
        canvas.backgroundColor = .clear
        
        controller.drawHierarchy(in: CGRect(origin: .zero, size: rect.size), afterScreenUpdates: true)
        
        let generatedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let image = generatedImage?.pngData() {
            UIImageWriteToSavedPhotosAlbum(UIImage(data: image)!, nil, nil, nil)
            print("Saved")
            self.showAlert.toggle()
        }
    }
}
