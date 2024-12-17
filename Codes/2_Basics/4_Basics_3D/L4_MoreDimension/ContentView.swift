//
//  ContentView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppModel.self) private var appModel
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.openImmersiveSpace) var openSpace
    @Environment(\.dismissImmersiveSpace) var dismissSpace
    
    @State private var spaceOpened = false
    @Binding var immersionStyle: ImmersionStyle

    var body: some View {
        VStack {
            Text("Learn about the Moon")
                .font(.title)
            
            Button("Moon View") {
                openWindow(id: "moon")
            }
            
            Button("Moon Volumetric View") {
                openWindow(id: "moon-volumetric")
            }
            
            Button("Model from URL") {
                openWindow(id: "url-model")
            }
            
            Button("Moon in Reality View") {
                openWindow(id: "moon-in-reality-view")
            }
        }
        .padding()
        
        VStack {
            Text("Learn in immersive space")
                .font(.title)
            
            Toggle("Open Space", isOn: $spaceOpened)
                .toggleStyle(.button)
                .onChange(of: spaceOpened) { _, show in
                    Task {
                        if show {
                            await openSpace(id: appModel.immersiveSpaceID)
                        } else {
                            await dismissSpace()
                        }
                    }
                    
                }
            
            ToggleImmersiveSpaceButton()
            
            HStack {
                Button("Mixed") {
                    immersionStyle = .mixed
                }
                
                Button("Progressive")  {
                    immersionStyle = .progressive
                }
                
                Button("Full") {
                    immersionStyle = .full
                }
            }
            
        }
        .padding()
        
        VStack {
            Text("Portal view")
                .font(.title)
            
            Button("Open Portal") {
                openWindow(id: "portal-view")
            }
        }
        
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(immersionStyle: .constant(.mixed))
        .environment(AppModel())
}
