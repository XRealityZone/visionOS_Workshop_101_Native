//
//  Utils.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

private let colors: [SimpleMaterial.Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple, .systemPink]

func changeToRandomColor(for entity: Entity) {
    let color = colors.randomElement()!
    changeColor(for: entity, to: color)
}

func changeColor(for entity: Entity, to color: SimpleMaterial.Color) {
    guard let _entity = entity as? ModelEntity else { return }
    if var model = entity.components[ModelComponent.self] {
        model.materials = [SimpleMaterial(color: color, isMetallic: false)]
        entity.components.set(model)
    }
}
