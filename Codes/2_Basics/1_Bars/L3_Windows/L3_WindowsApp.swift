//
//  L3_WindowsApp.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI

@main
struct L3_WindowsApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
                .frame(minWidth: 800, maxWidth: 1000,
                       minHeight: 600, maxHeight: 800)
        }
        .defaultSize(CGSize(width: 800, height: 600))
        .windowResizability(.contentSize)

        WindowGroup(id: "instructor") {
            InstructorView()
        }
     }
}
