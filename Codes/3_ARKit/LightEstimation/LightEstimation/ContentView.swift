//
//  ContentView.swift
//  LightEstimation
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
            Text("Light Estimation")
                .font(.title)
            
            Text("Lux: \(model.luvValue)")
            ToggleImmersiveSpaceButton()
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
