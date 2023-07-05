//
//  ButtonStyles.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI

struct ShimmeringButtonStyle: ButtonStyle {
    @State private var currentPoints = [UnitPoint(x: -1, y: 0), UnitPoint(x: 0, y: 0)]
    
    let colors: [Color] = [.blue, .cyan, .blue]
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: colors), startPoint: currentPoints[0], endPoint: currentPoints[1])
                    .onAppear {
                        withAnimation(.linear(duration: 1).delay(3).repeatForever(autoreverses: false)) {
                            currentPoints = [UnitPoint(x: 1, y: 0), UnitPoint(x: 2, y: 0)]
                        }
                    }
            )
            .cornerRadius(10.0)
    }
}
