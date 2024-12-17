//
//  SectionView.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI

struct SectionView: View {
    var sections: [Section] = []
    @State var section: Section?

    var body: some View {
        NavigationSplitView {
            List(sections, selection: $section) { section in
                NavigationLink(section.name, value: section)
            }
            .navigationTitle("Course Sections")
        } detail: {
            if let section {
                SectionDetailView(section: section)
            } else {
                Text("Please select a section")
            }
        }
    }

    init() {
        sections = Section.example
    }
}

#Preview {
    SectionView()
}
