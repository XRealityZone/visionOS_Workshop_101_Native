//
//  RotateGesture3DView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RotateGesture3DView: View {
    @State private var cube: ModelEntity = ModelEntity()
    
    var body: some View {
        RealityView { content in
            cube = ModelEntity(
                mesh: .generateBox(size: 0.2, cornerRadius: 0.02),
                materials: [SimpleMaterial(color: .yellow, isMetallic: false)]
            )
            cube.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
            cube.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.2, depth: 0.2)])
            content.add(cube)
        }
        .toolbar {
            Text("Rotate Gesture")
                .font(.title)
                .padding()
        }
        .gesture(
            RotateGesture3D()
                .targetedToEntity(cube)
                .onChanged { value in
                    let quatd = value.rotation.quaternion
                    let quatf = simd_quatf(ix: Float(quatd.imag.x), iy: Float(quatd.imag.y), iz: Float(quatd.imag.z), r: Float(quatd.real))
                    cube.transform.rotation = quatf
                }
        )
    }
}

#Preview {
    RotateGesture3DView()
}
