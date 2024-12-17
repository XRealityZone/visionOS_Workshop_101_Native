//
//  ContentView.swift
//  Ornaments
//
//  Created by xuchi on 2023/12/31.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("A view with an ornament")
            .ornament(
                visibility: .visible,
                attachmentAnchor: .scene(.leading),
                contentAlignment: .leading
            ) {
                OrnamentControl()
            }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
