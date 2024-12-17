//
//  L7_GestureApp.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/8.
//

import SwiftUI

@main
struct L7_GestureApp: App {

    @State private var appModel = AppModel()

    let size: CGFloat = 400

    init() {
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        
        WindowGroup(id: appModel.tapGesture) {
            TapGestureView()
                .frame(width: size, height: size)
                .frame(depth: size)
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.spatialTapGesture) {
            SpatialTapGestureView()
                .frame(width: size, height: size)
                .frame(depth: size)
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.dragGesture) {
            DragGestureView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.rotateGesture) {
            RotateGesture3DView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.magnifyGesture) {
            MagnifyGestureView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.gestureInOne) {
            GestureInOneView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.gravity) {
            GravityView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.force) {
            ForceView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.torque) {
            TorqueView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.restitution) {
            RestitutionView()
        }
        .windowStyle(.volumetric)
        
        WindowGroup(id: appModel.friction) {
            FrictionView()
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
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
