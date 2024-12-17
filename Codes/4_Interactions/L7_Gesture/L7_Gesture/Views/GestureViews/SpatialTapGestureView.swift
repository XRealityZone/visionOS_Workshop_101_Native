//
//  SpatialTapGestureView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SpatialTapGestureView: View {
    @State private var cube: ModelEntity = ModelEntity()

    var body: some View {
        RealityView { content in
            cube = ModelEntity(
                mesh: .generateBox(size: 0.2, cornerRadius: 0.02),
                materials: [SimpleMaterial(color: .red, isMetallic: false)]
            )
            cube.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
            cube.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.2, depth: 0.2)])
            content.add(cube)
        }
        .toolbar {
            Text("Spatial Tap Gesture")
                .font(.title)
                .padding()
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    print("Event location: \(value.location3D)")
                    
                    let location = value.convert(value.location3D, from: .local, to: .scene)
                    print("Location: \(location)")

                    let color: SimpleMaterial.Color = location.y > 0 ? .red : .blue
                    changeColor(for: cube, to: color)
                }
        )
    }
}

#Preview {
    SpatialTapGestureView()
}
