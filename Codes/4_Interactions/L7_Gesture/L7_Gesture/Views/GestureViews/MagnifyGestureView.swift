//
//  MagnifyGestureView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MagnifyGestureView: View {
    @State private var cube: ModelEntity = ModelEntity()
    
    var body: some View {
        RealityView { content in
            cube = ModelEntity(
                mesh: .generateBox(size: 0.2, cornerRadius: 0.02),
                materials: [SimpleMaterial(color: .green, isMetallic: false)]
            )
            cube.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
            cube.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.2, depth: 0.2)])
            content.add(cube)
        }
        .toolbar {
            Text("Magnify Gesture")
                .font(.title)
                .padding()
        }
        .gesture(
            MagnifyGesture()
                .targetedToEntity(cube)
                .onChanged { value in
                    let scale = Float(value.gestureValue.magnification)
                    cube.transform.scale = SIMD3<Float>(repeating: scale)
                }
        )
    }
}

#Preview {
    MagnifyGestureView()
}
