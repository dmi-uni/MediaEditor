//
//  View+HideKeyboard.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 05/12/22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
