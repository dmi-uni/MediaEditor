//
//  TextBox.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI
import PencilKit

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var isAdded: Bool = false
    var text: String = ""
    var isBold: Bool = true
    var textColor: Color = .white
    
    // Dragging the view
    var position: CGSize = .zero
    var lastPosition: CGSize = .zero
}
