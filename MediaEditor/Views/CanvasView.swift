//
//  CanvasView.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI
import PencilKit

struct CanvasView: View {
    @EnvironmentObject var canvasViewModel: CanvasViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { g -> AnyView in
                let size = g.frame(in: .global).size
                
                DispatchQueue.main.async {
                    if canvasViewModel.rect == .zero {
                        canvasViewModel.rect = g.frame(in: .global)
                    }
                }
                
                return AnyView(
                    ZStack {
                        // UIKit Canvas
                        Canvas(
                            canvas: $canvasViewModel.canvas,
                            imageData: $canvasViewModel.data,
                            toolPicker: $canvasViewModel.toolPicker,
                            rect: size
                        )
                        
                        
                        ForEach(canvasViewModel.textBoxes) { box in
                            Text(canvasViewModel.textBoxes[canvasViewModel.currentIndex].id == box.id && canvasViewModel.isAddingTextBox ? "" : box.text)
                                .font(.system(.title, weight: box.isBold ? .bold : .regular))
                                .foregroundColor(box.textColor)
                                .offset(x: box.position.width, y: box.position.height)
                            // drag gesture
                                .gesture(DragGesture().onChanged({ gesture in
                                    let current = gesture.translation
                                    let lastPos = box.lastPosition
                                    let newTranslation = CGSize(
                                        width: lastPos.width + current.width,
                                        height: lastPos.height + current.height
                                    )
                                    
                                    canvasViewModel.textBoxes[getIndex(textBox: box)].position = newTranslation
                                }).onEnded({ gesture in
                                    if abs(canvasViewModel.textBoxes[getIndex(textBox: box)].position.height) >= size.height / 2 {
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.error)
                                        
                                        withAnimation {
                                            canvasViewModel.textBoxes[getIndex(textBox: box)].position.height = canvasViewModel.textBoxes[getIndex(textBox: box)].lastPosition.height
                                        }
                                    }
                                    canvasViewModel.textBoxes[getIndex(textBox: box)].lastPosition = canvasViewModel.textBoxes[getIndex(textBox: box)].position
                                }))
                                .onTapGesture {
                                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                                    
                                    canvasViewModel.toolPicker.setVisible(false, forFirstResponder: canvasViewModel.canvas)
                                    canvasViewModel.canvas.resignFirstResponder()
                                    canvasViewModel.currentIndex = getIndex(textBox: box)
                                    withAnimation {
                                        canvasViewModel.isAddingTextBox = true
                                    }
                                }
                        }
                    }
                        .ignoresSafeArea(.keyboard)
                )
            }
        }
    }
    
    func getIndex(textBox: TextBox) -> Int {
        let index = canvasViewModel.textBoxes.firstIndex { (box) -> Bool in
            return textBox.id == box.id
        } ?? 0
        
        return index
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}

struct Canvas: UIViewRepresentable {
    @Binding var canvas: PKCanvasView
    @Binding var imageData: Data
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        
        // Appending the image to canvas
        if let image = UIImage(data: imageData) {
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            // Setting image to the back of the canvas
            let subview = canvas.subviews[0]
            subview.addSubview(imageView)
            subview.sendSubviewToBack(imageView)
            
            toolPicker.setVisible(true, forFirstResponder: canvas)
            toolPicker.addObserver(canvas)
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
}
