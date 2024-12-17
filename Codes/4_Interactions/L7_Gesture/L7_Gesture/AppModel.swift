//
//  AppModel.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/8.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let tapGesture = "tap-gesture"
    let spatialTapGesture = "spatial-tap-gesture"
    let dragGesture = "drag-gesture"
    let rotateGesture = "rotate-gesture"
    let magnifyGesture = "magnify-gesture"
    let gestureInOne = "gesture-in-one"
    
    let gravity = "gravity"
    let force = "force"
    let torque = "torque"
    let restitution = "restitution"
    let friction = "friction"
    
    var forward = false
    var backward = false
    var left = false
    var right = false
    
    func reset() {
        forward = false
        backward = false
        left = false
        right = false
    }
    
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
