//
//  GravityView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GravityView: View {
    @State private var entity = Entity()
    @State private var ball = Entity()
    
    private let radius: Float = 0.1
    
    var body: some View {
        RealityView { content in
            let floor = ModelEntity(
                mesh: .generateBox(width: 0.5, height: 0.03, depth: 0.5),
                materials: [SimpleMaterial(color: .gray, isMetallic: false)],
                collisionShape: .generateBox(width: 0.5, height: 0.03, depth: 0.5),
                mass: 0
            )
            floor.position = [0, -0.4, 0]
            
            ball = ModelEntity(
                mesh: .generateSphere(radius: radius),
                materials: [SimpleMaterial(color: .green, isMetallic: false)],
                collisionShape: .generateSphere(radius: radius),
                mass: 1
            )
            ball.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            
            content.add(floor)
            content.add(ball)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Button("Gravity", systemImage: "arrow.down") {
                    addGravity()
                }
            }
        }
    }
    
    private func addGravity() {
        if let ball = ball as? ModelEntity {
            ball.physicsBody?.isAffectedByGravity = true
        }
    }
}

#Preview {
    GravityView()
}
