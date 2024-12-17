//
//  ForceView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ForceView: View {
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
            
            content.add(floor)
            content.add(ball)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Button("Jump", systemImage: "arrow.up") {
                    addForce(strength: 100)
                }
            }
            
            ToolbarItem(placement: .bottomOrnament) {
                Button("Impulse", systemImage: "water.waves.and.arrow.up") {
                    addImpulse(impulse: 2)
                }
            }
        }
    }
    
    private func addForce(strength: Float) {
        if let ball = ball as? ModelEntity {
            ball.addForce([0, strength, 0], relativeTo: nil)
        }
    }
    
    private func addImpulse(impulse: Float) {
        if let ball = ball as? ModelEntity {
            ball.applyLinearImpulse([0, impulse, 0], relativeTo: nil)
        }
    }
}
#Preview {
    ForceView()
}
