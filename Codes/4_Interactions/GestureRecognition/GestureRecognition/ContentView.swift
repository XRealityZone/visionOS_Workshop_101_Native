//
//  ContentView.swift
//  GestureRecognition
//
//  Created by xuchi on 2024/8/8.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    var body: some View {
        VStack {
            Text("Gesture Recognition")
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
