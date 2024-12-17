//
//  ContentView.swift
//  WindowVolumeSpace
//
//  Created by xuchi on 2024/11/13.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) var openImmersiveSpace

    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, world!")

            Button("Open window") {
                openWindow(id: "hello")
            }

            Button("Open volume") {
                openWindow(id: "helloVolume")
            }

            Button("Open space") {
                Task {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                }
            }

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
