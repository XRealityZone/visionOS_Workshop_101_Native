//
//  AppModel.swift
//  SceneReconstruction
//
//  Created by xuchi on 2024/7/21.
//

import SwiftUI
import ARKit
import RealityKit

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
    
    // Scene reconstruction
    private let session = ARKitSession()
    private let sceneReconstruction = SceneReconstructionProvider()
    
    private var rootEntity = Entity()
    private var meshEntities = [UUID: ModelEntity]()

    func setupContentEntity() -> Entity {
        return rootEntity
    }
    
    func runSession() async {
        do {
            if SceneReconstructionProvider.isSupported {
                print("Scene reconstruction supported, ready to start session.")
                try await session.run([sceneReconstruction])
            } else {
                print("Scene reconstruction not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processSceneReconstructionUpdates() async {
        for await update in sceneReconstruction.anchorUpdates {
            let meshAnchor = update.anchor

            guard let shape = try? await ShapeResource.generateStaticMesh(from: meshAnchor) else { continue }
            switch update.event {
            case .added:
                let entity = ModelEntity()
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
                entity.components.set(InputTargetComponent())
                
                entity.physicsBody = PhysicsBodyComponent(mode: .static)
                print("Description: \(meshAnchor.description)")
                meshEntities[meshAnchor.id] = entity
                rootEntity.addChild(entity)
            case .updated:
                guard let entity = meshEntities[meshAnchor.id] else { continue }
                entity.transform = Transform(matrix: meshAnchor.originFromAnchorTransform)
                entity.collision?.shapes = [shape]
            case .removed:
                meshEntities[meshAnchor.id]?.removeFromParent()
                meshEntities.removeValue(forKey: meshAnchor.id)
            }
        }
    }
    
}
