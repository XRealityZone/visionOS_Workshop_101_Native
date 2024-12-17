//
//  WindowVolumeSpaceApp.swift
//  WindowVolumeSpace
//
//  Created by xuchi on 2024/11/13.
//

import SwiftUI

@main
struct WindowVolumeSpaceApp: App {
    @State private var appModel = AppModel()
    // ...
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        WindowGroup(id: "hello") {
            HelloVisionOSView()
        }

        WindowGroup(id: "helloVolume") {
            HelloVisionOSView()
        }
        .windowStyle(.volumetric)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(
            selection: .constant(.progressive),
            in: .progressive)
    }
}
