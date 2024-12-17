//
//  ContentView.swift
//  RoomTracking
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(AppModel.self) var model

    var body: some View {
        VStack {
            Text("Room Tracking")
                .font(.title)

            ToggleImmersiveSpaceButton()
            
            if model.setupComplete {
                Button("Add cubes") {
                    Task {
                        await model.setupCubes()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
