//
//  AppModel.swift
//  GestureRecognition
//
//  Created by xuchi on 2024/8/8.
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
    
    private var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    func setupContentEntity() -> Entity {
        let root = Entity()
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
            switch update.event {
            case .updated:
                let anchor = update.anchor
                
                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }
                
                // Update left hand info.
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                }
            default:
                break
            }
        }
    }
    
    func computeTransformOfUserPerformedCircleGesture() -> simd_float4x4? {
        // Get the latest hand anchors, return false if either of them isn't tracked.
        guard let leftHandAnchor = latestHandTracking.left,
              let rightHandAnchor = latestHandTracking.right,
              leftHandAnchor.isTracked, rightHandAnchor.isTracked else {
            return nil
        }
        
        // Get all required joints and check if they are tracked.
        guard
            let leftHandThumbKnuckle = leftHandAnchor.handSkeleton?.joint(.thumbKnuckle),
            let leftHandThumbTipPosition = leftHandAnchor.handSkeleton?.joint(.thumbTip),
            let leftHandIndexFingerTip = leftHandAnchor.handSkeleton?.joint(.indexFingerTip),
            let rightHandThumbKnuckle = rightHandAnchor.handSkeleton?.joint(.thumbKnuckle),
            let rightHandThumbTipPosition = rightHandAnchor.handSkeleton?.joint(.thumbTip),
            let rightHandIndexFingerTip = rightHandAnchor.handSkeleton?.joint(.indexFingerTip),
            leftHandIndexFingerTip.isTracked && leftHandThumbTipPosition.isTracked &&
            rightHandIndexFingerTip.isTracked && rightHandThumbTipPosition.isTracked &&
            leftHandThumbKnuckle.isTracked && rightHandThumbKnuckle.isTracked
        else {
            return nil
        }
        
        // Get the position of all joints in world coordinates.
        let originFromLeftHandThumbKnuckleTransform = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, leftHandThumbKnuckle.anchorFromJointTransform
        ).columns.3.xyz
        let originFromLeftHandThumbTipTransform = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, leftHandThumbTipPosition.anchorFromJointTransform
        ).columns.3.xyz
        let originFromLeftHandIndexFingerTipTransform = matrix_multiply(
            leftHandAnchor.originFromAnchorTransform, leftHandIndexFingerTip.anchorFromJointTransform
        ).columns.3.xyz
        let originFromRightHandThumbKnuckleTransform = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, rightHandThumbKnuckle.anchorFromJointTransform
        ).columns.3.xyz
        let originFromRightHandThumbTipTransform = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, rightHandThumbTipPosition.anchorFromJointTransform
        ).columns.3.xyz
        let originFromRightHandIndexFingerTipTransform = matrix_multiply(
            rightHandAnchor.originFromAnchorTransform, rightHandIndexFingerTip.anchorFromJointTransform
        ).columns.3.xyz
        
        let indexFingersDistance = distance(originFromLeftHandIndexFingerTipTransform, originFromRightHandIndexFingerTipTransform)
        let thumbsDistance = distance(originFromLeftHandThumbTipTransform, originFromRightHandThumbTipTransform)
        
        // Circle gesture detection is true when the distance between the index finger tips centers
        // and the distance between the thumb tip centers is each less than four centimeters.
        let isCircleShapeGesture = indexFingersDistance < 0.04 && thumbsDistance < 0.04
        if !isCircleShapeGesture {
            return nil
        }
        
        // Compute a position in the middle of the circle gesture.
        let halfway = (originFromRightHandIndexFingerTipTransform - originFromLeftHandThumbTipTransform) / 2
        let circleMidpoint = originFromRightHandIndexFingerTipTransform - halfway
        
        // Compute the vector from left thumb knuckle to right thumb knuckle and normalize (X axis).
        let xAxis = normalize(originFromRightHandThumbKnuckleTransform - originFromLeftHandThumbKnuckleTransform)
        
        // Compute the vector from right thumb tip to right index finger tip and normalize (Y axis).
        let yAxis = normalize(originFromRightHandIndexFingerTipTransform - originFromRightHandThumbTipTransform)
        
        let zAxis = normalize(cross(xAxis, yAxis))
        
        // Create the final transform for the circle gesture from the three axes and midpoint vector.
        let circleMidpointWorldTransform = simd_matrix(
            SIMD4(xAxis.x, xAxis.y, xAxis.z, 0),
            SIMD4(yAxis.x, yAxis.y, yAxis.z, 0),
            SIMD4(zAxis.x, zAxis.y, zAxis.z, 0),
            SIMD4(circleMidpoint.x, circleMidpoint.y, circleMidpoint.z, 1)
        )
        return circleMidpointWorldTransform
    }
}
