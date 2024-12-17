//
//  GestureInOneView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct GestureInOneView: View {
    @State private var cube: ModelEntity = ModelEntity()
    @State private var entity = Entity()
    
    var body: some View {
        RealityView { content in
            cube = ModelEntity(
                mesh: .generateBox(size: 0.2, cornerRadius: 0.02),
                materials: [SimpleMaterial(color: .white, isMetallic: false)]
            )
            cube.components.set(InputTargetComponent(allowedInputTypes: [.indirect, .direct]))
            cube.collision = CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.2, depth: 0.2)])
            entity.addChild(cube)
            content.add(entity)
        }
        .toolbar {
            Text("All in one")
                .font(.title)
                .padding()
        }
        .gesture(
            DragGesture()
                .targetedToEntity(cube)
                .onChanged { value in
                    cube.position = value.convert(value.location3D, from: .local, to: cube.parent!)
                }
        )
        .simultaneousGesture(
            RotateGesture3D()
                .targetedToEntity(cube)
                .onChanged { value in
                    let quatd = value.rotation.quaternion
                    let quatf = simd_quatf(ix: Float(quatd.imag.x), iy: Float(quatd.imag.y), iz: Float(quatd.imag.z), r: Float(quatd.real))
                    cube.transform.rotation = quatf
                }
        )
        .simultaneousGesture(
            MagnifyGesture()
                .targetedToEntity(cube)
                .onChanged { value in
                    let scale = Float(value.gestureValue.magnification)
                    cube.transform.scale = SIMD3<Float>(repeating: scale)
                }
        )
    }
}

extension SimultaneousGesture<SimultaneousGesture<DragGesture, MagnifyGesture>, RotateGesture3D>.Value {
    func components() -> (Vector3D, Size3D, Rotation3D) {
        let translation = self.first?.first?.translation3D ?? .zero
        let magnification = self.first?.second?.magnification ?? 1
        let size = Size3D(width: magnification, height: magnification, depth: magnification)
        let rotation = self.second?.rotation ?? .identity
        return (translation, size, rotation)
    }
}

#Preview {
    GestureInOneView()
}
