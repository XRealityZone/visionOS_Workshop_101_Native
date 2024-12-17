//
//  ImmersiveView.swift
//  GestureRecognition
//
//  Created by xuchi on 2024/8/8.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppModel.self) var model
    private let ball = ModelEntity(
        mesh: .generateSphere(radius: 0.04),
        materials: [SimpleMaterial(color: .white, roughness: 0.6, isMetallic: false)]
    )
    
    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
        } update: { updateContent in
            if let handsCenterTransform = model.computeTransformOfUserPerformedCircleGesture() {
                let position = Pose3D(handsCenterTransform)!.position
                ball.position = SIMD3<Float>(position.vector)
                updateContent.add(ball)
                
            }
            
        }
        .task {
            await model.runSession()
        }
        .task {
            await model.processHandUpdates()
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
