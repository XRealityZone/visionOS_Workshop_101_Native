//
//  GestureView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI

struct GestureView: View {
    
    @Environment(AppModel.self) var appModel
    @Environment(\.openWindow) var openWindow

    var body: some View {
        VStack {
            VStack {
                Text("Tap Gesture")
                    .font(.title)
                Button("Tap") {
                    openWindow(id: appModel.tapGesture)
                }
                .font(.title)
            }
            
            VStack {
                Text("Spatial Tap Gesture")
                    .font(.title)
                Button("Spatial Tap") {
                    openWindow(id: appModel.spatialTapGesture)
                }
                .font(.title)
            }
            
            VStack {
                Text("Drag Gesture")
                    .font(.title)
                Button("Drag") {
                    openWindow(id: appModel.dragGesture)
                }
                .font(.title)
            }
            
            VStack {
                Text("Rotate Gesture")
                    .font(.title)
                Button("Rotate") {
                    openWindow(id: appModel.rotateGesture)
                }
                .font(.title)
            }
            
            VStack {
                Text("Magnify Gesture")
                    .font(.title)
                Button("Magnify") {
                    openWindow(id: appModel.magnifyGesture)
                }
                .font(.title)
            }
            
            VStack {
                Text("Gesture in One")
                    .font(.title)
                Button("All in one") {
                    openWindow(id: appModel.gestureInOne)
                }
                .font(.title)
            }
        }
    }
}

#Preview {
    GestureView()
}
