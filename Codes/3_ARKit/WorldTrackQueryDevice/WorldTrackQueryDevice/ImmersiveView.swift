//
//  ImmersiveView.swift
//  WorldTrackQueryDevice
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @Environment(AppModel.self) var model
    @State private var updateFacingTask: Task<Void, Never>? = nil

    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
            
            // Updates and renders the wall in front of the person at 10 Hz.
            updateFacingTask = run(model.updateFacing, withFrequency: 10)
        }
        .task {
            await model.runSession()
        }
        .onDisappear {
            updateFacingTask?.cancel()
        }
    }
    
    func run(_ function: @escaping () -> Void, withFrequency freqHz: UInt64) -> Task<Void, Never> {
        return Task {
            while true {
                if Task.isCancelled {
                    return
                }
                
                // Sleeps for 1 s / Hz before calling the function.
                let nanoSecondsToSleep: UInt64 = NSEC_PER_SEC / freqHz
                do {
                    try await Task.sleep(nanoseconds: nanoSecondsToSleep)
                } catch {
                    // Sleep fails when the Task is in a canceled state. Exit the loop.
                    return
                }
                
                function()
            }
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
