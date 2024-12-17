//
//  ImmersiveView.swift
//  WindowVolumeSpace
//
//  Created by xuchi on 2024/11/13.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            if let immersiveContentEntity = try? await Entity(
                named: "Immersive",
                in: realityKitContentBundle)
            {
                content.add(immersiveContentEntity)
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
