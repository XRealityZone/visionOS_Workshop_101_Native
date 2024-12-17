//
//  ProjectView.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI

struct ProjectView: View {
    @Environment(\.openURL) var openURL

    let urlStr = "https://github.com/xuchi16/vision-os-workshop"
    
    var body: some View {
        VStack {
            Text("Project introductions")
                .font(.title)
        }
        .toolbar {
#if os(visionOS)
            ToolbarItemGroup(placement: .bottomOrnament) {
                Button("Website", systemImage: "safari") {
                    openURL(URL(string: urlStr)!)
                }

                Button("Tag", systemImage: "tag") {
                    print("Tag the section")
                }
            }
#else
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Website", systemImage: "safari") {
                    openURL(URL(string: urlStr)!)
                }

                Button("Tag", systemImage: "tag") {
                    print("Tag the section")
                }
            }
#endif
        }
    }
}

#Preview {
    ProjectView()
}
