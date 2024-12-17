//
//  TorqueView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct TorqueView: View {
    @State private var entity = Entity()
    @State private var cube = Entity()
    
    private let size: Float = 0.1
    
    var body: some View {
        RealityView { content in
            let floor = ModelEntity(
                mesh: .generateBox(width: 0.5, height: 0.03, depth: 0.5),
                materials: [SimpleMaterial(color: .gray, isMetallic: false)],
                collisionShape: .generateBox(width: 0.5, height: 0.03, depth: 0.5),
                mass: 0
            )
            floor.position = [0, -0.4, 0]
            
            cube = ModelEntity(
                mesh: .generateBox(size: size),
                materials: [SimpleMaterial(color: .green, isMetallic: false)],
                collisionShape: .generateBox(size: SIMD3<Float>(repeating: size)),
                mass: 1
            )
            
            content.add(floor)
            content.add(cube)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Button("Jump", systemImage: "arrow.right") {
                    addTorque(strength: 5)
                }
            }
            
            ToolbarItem(placement: .bottomOrnament) {
                Button("Impulse", systemImage: "arrow.turn.down.right") {
                    applyAngularImpulse(impulse: 0.05)
                }
            }
        }
    }
    
    private func addTorque(strength: Float) {
        if let cube = cube as? ModelEntity {
            cube.addTorque([0, strength, 0], relativeTo: nil)
        }
    }
    
    private func applyAngularImpulse(impulse: Float) {
        if let cube = cube as? ModelEntity {
            cube.applyAngularImpulse([0, impulse, 0], relativeTo: nil)
        }
    }
}

#Preview {
    TorqueView()
}
