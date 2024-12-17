//
//  ImmersiveView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            guard let moon = try? await Entity(named: "Moon") else {
                return
            }
            moon.position = [0, 2, -1.5]
            content.add(moon)
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
