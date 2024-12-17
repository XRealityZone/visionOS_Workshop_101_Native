//
//  HomeView.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI
#if os(visionOS)
import RealityKit
import RealityKitContent
#endif


struct HomeView: View {
    
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    @State private var isIntroWindowOpened = false
    
    var body: some View {
        VStack {
            Text("Hello visionOS!")
                .font(.title)
        }
        .padding()
    }
}
