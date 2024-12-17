//
//  AppModel.swift
//  HandTrack
//
//  Created by xuchi on 2024/7/16.
//

import SwiftUI
import RealityKit
import ARKit

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
    
    // Hand track
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()
    
    private var fingerEntities: [HandAnchor.Chirality: ModelEntity] = [:]
    
    func setupContentEntity() -> Entity {
        let root = Entity()
        let leftTip = createFingertip(color: .blue)
        let rightTip = createFingertip(color: .red)
        root.addChild(leftTip)
        root.addChild(rightTip)
        
        fingerEntities[.left] = leftTip
        fingerEntities[.right] = rightTip
        
        return root
    }
    
    func runSession() async {
        do {
            if HandTrackingProvider.isSupported {
                print("Hand track supported, ready to start session.")
                try await session.run([handTracking])
            } else {
                print("Hand track not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processHandUpdates() async {
        for await update in handTracking.anchorUpdates {
            let handAnchor = update.anchor
            guard handAnchor.isTracked else { continue }
            
            guard let fingertip = 
                    handAnchor.handSkeleton?.joint(.indexFingerTip) else { continue }
            
            guard fingertip.isTracked else { continue }
            
            let fingertipOriginFromIndex = 
                calculateJointTransform(handAnchor: handAnchor, joint: fingertip)
            
            fingerEntities[handAnchor.chirality]?
                .setTransformMatrix(fingertipOriginFromIndex, relativeTo: nil)
        }
    }

    private func getPosition(_ transform: float4x4) -> SIMD3<Float> {
        return transform.columns.3.xyz
    }
    
    private func calculateJointTransform(handAnchor: HandAnchor, joint: HandSkeleton.Joint) -> float4x4 {
        let originFromWrist = handAnchor.originFromAnchorTransform
        let wristFromIndex = joint.anchorFromJointTransform
        return matrix_multiply(originFromWrist, wristFromIndex)
    }
    
    
    private func createFingertip(color: SimpleMaterial.Color) -> ModelEntity {
        return ModelEntity(
            mesh: .generateSphere(radius: 0.01),
            materials: [SimpleMaterial(color: color, isMetallic: false)]
        )
    }
}
