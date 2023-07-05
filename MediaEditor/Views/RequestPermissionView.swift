//
//  RequestPermissionView.swift
//  MediaEditor
//
//  Created by Danil Masnaviev on 04/12/22.
//

import SwiftUI

struct RequestPermissionView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("duck")
            
            Text("Access Your Photos And Videos")
                .fontWeight(.semibold)
            
            Button {
                print("Action")
            } label: {
                Text("Allow Access")
                    .fontWeight(.semibold)
            }.buttonStyle(ShimmeringButtonStyle())
        }
        .padding()
    }
}

struct RequestPermissionView_Previews: PreviewProvider {
    static var previews: some View {
        RequestPermissionView()
    }
}
