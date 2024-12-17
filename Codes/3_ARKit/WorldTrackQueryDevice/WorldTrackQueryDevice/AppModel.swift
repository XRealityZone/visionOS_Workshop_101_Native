//
//  AppModel.swift
//  WorldTrackQueryDevice
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import ARKit
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()
    private var rootEntity = Entity()
    private var cube = Entity()
    
    func setupContentEntity() -> Entity {
        cube = ModelEntity(
            mesh: .generateBox(size: 0.4),
            materials: [SimpleMaterial(color: .blue, isMetallic: false)])
        
        cube.position = [0, 1.2, -1.5]
        rootEntity.addChild(cube)
        return rootEntity
    }
    
    func runSession() async {
        do {
            if WorldTrackingProvider.isSupported {
                print("World tracking supported, ready to start session.")
                try await session.run([worldTracking])
            } else {
                print("World tracking not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }

    func updateFacing() {
        let devicePosition = getDevicePosition()
        let entityPosition = cube.position
        cube.look(at: devicePosition, from: entityPosition, relativeTo: nil)
    }
    
    func getDevicePosition() -> SIMD3<Float> {
        let transform = getDeviceTransform()
        return [transform.columns.3.x, transform.columns.3.y, transform.columns.3.z]
    }
    
    func getDeviceTransform() -> simd_float4x4 {
        guard let pose = worldTracking.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else {
            return simd_float4x4()
        }
        return pose.originFromAnchorTransform
    }
}
