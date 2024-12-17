//
//  ContentView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/8.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State var tag = "gesture"

    var body: some View {
        TabView(selection: $tag) {
            GestureView()
                .tabItem {
                    Label("Gesture", systemImage: "hand.raised")
                }
                .tag("gesture")
            
            PhysicsView()
                .tabItem {
                    Label("Physics", systemImage: "globe.asia.australia.fill")
                }
                .tag("physics")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
