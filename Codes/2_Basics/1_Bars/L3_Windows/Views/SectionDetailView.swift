//
//  SectionDetailView.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import SwiftUI

struct SectionDetailView: View {
    
    var section: Section
    var body: some View {
        VStack {
            Text("Section \(section.id). \(section.description)")
                .font(.body)
                .padding()
                .navigationTitle(section.name)
        }
    }
    
    init(section: Section) {
        self.section = section
    }
}
