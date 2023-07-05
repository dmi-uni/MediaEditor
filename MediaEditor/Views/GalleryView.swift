//
//  GalleryView.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI
import PhotosUI

struct GalleryView: View {
    @StateObject var canvasViewModel = CanvasViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    if let data = canvasViewModel.data, let _ = UIImage(data: data) {
                        CanvasView()
                            .environmentObject(canvasViewModel)
                            .toolbar {
                                // Toolbar in text editing mode
                                if canvasViewModel.isAddingTextBox {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button {
                                            canvasViewModel.cancelTextBoxEditing()
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                    
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button {
                                            canvasViewModel.saveTextBox()
                                        } label: {
                                            Text("Done")
                                                .fontWeight(.bold)
                                                .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                    
                                    ToolbarItemGroup(placement: .bottomBar) {
                                        ColorPicker("Text Color", selection: $canvasViewModel.textBoxes[canvasViewModel.currentIndex].textColor)
                                            .labelsHidden()
                                        
                                        Button {
                                            canvasViewModel.textBoxes[canvasViewModel.currentIndex].isBold.toggle()
                                        } label: {
                                            Image(systemName: "bold")
                                                .font(.title2)
                                                .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                }
                                
                                // Toolbar in drawing mode
                                else {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        Button {
                                            print("Cancelled")
                                            canvasViewModel.cancelImageEditing()
                                        } label: {
                                            Image(systemName: "multiply.circle")
                                                .font(.title2)
                                                .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                    
                                    // TODO: Use segmented picker to switch editing modes
                                    
//                                    ToolbarItem(placement: .principal) {
//                                        Picker("Mode", selection: $canvasViewModel.selectedMode) {
//                                            ForEach(canvasViewModel.editModes, id: \.self) {
//                                                Text($0)
//                                            }
//                                        }
//                                        .pickerStyle(.segmented)
//                                    }
                                    
                                    ToolbarItem(placement: .principal) {
                                        Button {
                                            print(canvasViewModel.currentIndex)
                                            canvasViewModel.textBoxes.append(TextBox())
                                            canvasViewModel.currentIndex = canvasViewModel.textBoxes.count - 1
                                            print(canvasViewModel.currentIndex)
                                            
                                            print(canvasViewModel.textBoxes)
                                            
                                            withAnimation {
                                                canvasViewModel.isAddingTextBox.toggle()
                                                canvasViewModel.toolPicker.setVisible(false, forFirstResponder: canvasViewModel.canvas)
                                                canvasViewModel.canvas.resignFirstResponder()
                                            }
                                        } label: {
                                            HStack {
                                                Image(systemName: "text.badge.plus")
                                                Text("Add Text")
                                            }
                                            .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                    
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button {
                                            print("Downloading...")
                                            canvasViewModel.saveImage()
                                        } label: {
                                            Image(systemName: "arrow.down.circle")
                                                .font(.title2)
                                                .foregroundColor(Color("ToolbarButtonColor"))
                                        }
                                    }
                                    
                                    ToolbarItem(placement: .bottomBar) {
                                        Text("")
                                    }
                                }
                            }
                            .navigationBarTitleDisplayMode(.inline)
                        
                        if canvasViewModel.isAddingTextBox {
                            // Darkening the background
                            Color.black.opacity(0.75)
                                .onTapGesture {
                                    hideKeyboard()
                                }
                            
                            TextField("Type Here", text: $canvasViewModel.textBoxes[canvasViewModel.currentIndex].text)
                                .font(.system(.title, weight: canvasViewModel.textBoxes[canvasViewModel.currentIndex].isBold ? .bold : .regular))
                                .preferredColorScheme(.dark)
                                .foregroundColor(canvasViewModel.textBoxes[canvasViewModel.currentIndex].textColor)
                                .padding()
                        }
                    } else {
                        PhotosPicker(
                            selection: $canvasViewModel.imageSelection,
                            matching: .images
                        ) {
                            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .leading, endPoint: .trailing)
                                .mask {
                                    Image(systemName: "plus.app.fill")
                                        .font(.system(size: 72))
                                }
                        }
                    }
                }
            }
        }
        .alert("Saved", isPresented: $canvasViewModel.showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
