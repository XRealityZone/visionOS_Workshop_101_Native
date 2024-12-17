//
//  ImmersiveView.swift
//  RoomTracking
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    @Environment(AppModel.self) var model
    
    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
        }
        .task {
            await model.runSession()
        }
        .task {
            await model.processRoomTrackingProcessor()
        }
        .task {
            await model.processWorldTrackUpdates()
        }
        
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
