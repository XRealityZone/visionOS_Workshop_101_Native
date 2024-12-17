//
//  ContentView.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI

struct ContentView: View {
    @State var currentTag = "home"

    var body: some View {
        TabView(selection: $currentTag) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag("home")

            SectionView()
                .tabItem {
                    Label("Sections", systemImage: "list.triangle")
                }
                .tag("sections")

            ProjectView()
                .tabItem {
                    Label("Projects", systemImage: "macbook.and.visionpro")
                }
                .tag("projects")
        }
    }
}
