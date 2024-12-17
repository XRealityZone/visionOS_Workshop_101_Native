//
//  MoonRealityView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import RealityKit
import SwiftUI

struct MoonRealityView: View {
    var body: some View {
        RealityView { content, attachments in
            guard let moon = try? await Entity(named: "Moon") else {
                return
            }
            moon.position = [-0.3, 0, 0]
            content.add(moon)

            if let moonTag = attachments.entity(for: "moon-tag") {
                moonTag.position = [0, -0.15, 0]
                moon.addChild(moonTag)
            }

            guard let sun = try? await Entity(named: "Sun") else {
                return
            }
            sun.position = [0.3, 0, 0]
            content.add(sun)

            if let sunTag = attachments.entity(for: "sun-tag") {
                sunTag.position = [0, -0.15, 0]
                sun.addChild(sunTag)
            }
        }
        attachments: {
            Attachment(id: "moon-tag") {
                Text("Moon")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }

            Attachment(id: "sun-tag") {
                Text("Sun")
                    .font(.title)
                    .padding()
                    .glassBackgroundEffect()
            }
        }
    }
}

#Preview {
    MoonRealityView()
}
