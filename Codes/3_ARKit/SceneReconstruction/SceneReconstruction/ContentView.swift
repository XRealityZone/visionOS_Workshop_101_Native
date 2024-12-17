//
//  ContentView.swift
//  SceneReconstruction
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Scene Reconstruction")
                .font(.title)

            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
