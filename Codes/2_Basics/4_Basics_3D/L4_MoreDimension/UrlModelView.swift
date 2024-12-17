//
//  UrlModelView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import RealityKit
import SwiftUI

struct UrlModelView: View {
    var body: some View {
        let cakeUrl = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/pancakes/pancakes.usdz")!
        let cosmonautUrl = URL(string: "https://developer.apple.com/augmented-reality/quick-look/models/cosmonaut/CosmonautSuit_en.reality")!
        Model3D(url: cosmonautUrl) { model in
            model
//                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    UrlModelView()
}
