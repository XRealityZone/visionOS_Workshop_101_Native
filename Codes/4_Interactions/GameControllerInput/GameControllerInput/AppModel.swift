//
//  AppModel.swift
//  GameControllerInput
//
//  Created by xuchi on 2024/8/8.
//

import SwiftUI
import GameController

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    var connected = false
    var controller: GCController?
    
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    init() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCControllerDidConnect, object: nil, queue: nil, using: didConnectController)
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.GCControllerDidDisconnect, object: nil, queue: nil, using: didDisConnectController)
        
        GCController.startWirelessControllerDiscovery {}
    }
    
    @Sendable
    func didConnectController(_ notification: Notification) {
        connected = true
        guard let controller = notification.object as? GCController else { return }
        
        print("Connected \(controller.productCategory)")
//        controller.extendedGamepad?.buttonA.pressedChangedHandler = { (button, value, pressed) in self.button("X", pressed)}
    }
    
    func didDisConnectController(_ notification: Notification) {
        connected = false
        
        print("Disconntected")
    }
    
    
}
