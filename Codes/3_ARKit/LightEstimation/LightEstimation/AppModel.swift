//
//  AppModel.swift
//  LightEstimation
//
//  Created by xuchi on 2024/7/21.
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
    
    // Light Estimation
    
    private let session = ARKitSession()
    private let lightEstimation = EnvironmentLightEstimationProvider()
    
    private var rootEntity = Entity()
    var luvValue: Float = 0

    func setupContentEntity() -> Entity {
        return rootEntity
    }
    
    func runSession() async {
        do {
            if EnvironmentLightEstimationProvider.isSupported {
                print("Light estimation is supported")
                try await session.run([lightEstimation])
            } else {
                print("Light estimation is not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processLightEsitmationUpdates() async {
        for await update in lightEstimation.anchorUpdates {
            let anchor = update.anchor
            
            let luvValue = anchor.clippingPointLux
            let texture = anchor.environmentTexture

            print("Lux value: \(luvValue)")
        }
    }
    
}
