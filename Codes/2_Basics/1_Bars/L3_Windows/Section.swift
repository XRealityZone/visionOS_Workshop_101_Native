//
//  Section.swift
//  L3_Windows
//
//  Created by xuchi on 2024/6/25.
//

import Foundation

struct Section: Identifiable, Hashable {
    var id: Int
    var name: String
    var description: String
    
    static let example = [
        Section(id: 1, 
                name: "Introduction",
                description: "Overview of the course."),
        Section(id: 2,
                name: "2D Elements",
                description: "Introduce new 2D elements, including tab bar, side bar, tool bar and ornaments."),
        Section(id: 3,
                name: "3D Elements",
                description: "Explain how to add 3D elements for window, volume and space in visionOS."),
        Section(id: 4,
                name: "ARKit",
                description: "Connect and interact with the world by using ARKit.")
    ]
}
