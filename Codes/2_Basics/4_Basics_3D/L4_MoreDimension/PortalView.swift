//
//  PortalView.swift
//  L4_MoreDimension
//
//  Created by xuchi on 2024/6/30.
//

import RealityKit
import SwiftUI

struct PortalView: View {
    var body: some View {
        RealityView { content in
            let world = makeWorld()
            let portal = makePortal(world: world)

            content.add(world)
            content.add(portal)
        }
    }

    public func makeWorld() -> Entity {
        let world = Entity()
        world.components[WorldComponent.self] = .init()

        // 设置光照环境
        guard let environment = try? EnvironmentResource.load(named: "Sunlight") else {
            print("No environment resource found")
            return world
        }
        world.components[ImageBasedLightComponent.self] = .init(source: .single(environment), intensityExponent: 10)
        world.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight: world)

        // 3D 物体
        guard let moon = try? Entity.load(named: "Moon") else {
            print("Moon not found")
            return world
        }
        guard let sun = try? Entity.load(named: "Sun") else {
            print("Sun not found")
            return world
        }

        moon.position = [-0.15, 0, -0.5]
        sun.position = [0.15, 0, -0.5]
        world.addChild(moon)
        world.addChild(sun)

        return world
    }

    public func makePortal(world: Entity) -> Entity {
        let portal = Entity()

        portal.components[ModelComponent.self] = .init(
            mesh: .generatePlane(width: 0.5, height: 0.5, cornerRadius: 0.5),
            materials: [PortalMaterial()])
        portal.components[PortalComponent.self] = .init(target: world)
        return portal
    }
}

#Preview {
    PortalView()
}
