//
//  AppModel.swift
//  WorldTrack
//
//  Created by xuchi on 2024/7/17.
//

import SwiftUI
import RealityKit
import ARKit

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
    
    var setupComplete = false
    
    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()
    private var rootEntity = Entity()
    private var worldAnchors: [UUID: WorldAnchor] = [:]
    private var entitiesBeingAnchored: [UUID: Entity] = [:]
    private var anchoredEntities: [UUID: Entity] = [:]
    
    func setupContentEntity() -> Entity{
        return rootEntity
    }
    
    func setupCubes() async {
        let cube1 = ModelEntity(
            mesh: .generateBox(size: 0.4, cornerRadius: 0),
            materials: [SimpleMaterial(color: .blue, isMetallic: false)]
        )
        cube1.position = [-0.6, 1, -1.5]
        rootEntity.addChild(cube1)
        
        let cube2 = ModelEntity(
            mesh: .generateBox(size: 0.4, cornerRadius: 0),
            materials: [SimpleMaterial(color: .red, isMetallic: false)]
        )
        cube2.position = [0.6, 1, -1.5]
        await attachToWorldAnchor(cube2)
        rootEntity.addChild(cube2)
    }
    
    func attachToWorldAnchor(_ entity: Entity) async {
        let anchor = WorldAnchor(originFromAnchorTransform: entity.transformMatrix(relativeTo: nil))
        entitiesBeingAnchored[anchor.id] = entity
        do {
            print("Attach world anchor")
            try await worldTracking.addAnchor(anchor)
        } catch {
            print("Failed to add world anchor")
            entitiesBeingAnchored.removeValue(forKey: anchor.id)
        }
    }
    
    func runSession() async {
        do {
            if WorldTrackingProvider.isSupported {
                print("World tracking supported, ready to start session.")
                try await session.run([worldTracking])
                setupComplete = true
            } else {
                print("World tracking not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processWorldTrackUpdates() async {
        for await update in worldTracking.anchorUpdates {
            let anchor = update.anchor
            
            if update.event != .removed {
                worldAnchors[anchor.id] = anchor
            } else {
                worldAnchors.removeValue(forKey: anchor.id)
            }
            
            switch update.event {
            case .added:
                print("Anchor position added")
                if let entityBeingAnchored = entitiesBeingAnchored[anchor.id] {
                    entitiesBeingAnchored.removeValue(forKey: anchor.id)
                    anchoredEntities[anchor.id] = entityBeingAnchored
                    rootEntity.addChild(entityBeingAnchored)
                } else {
                    if anchoredEntities[anchor.id] == nil {
                        Task {
                            await removeAnchorWithID(anchor.id)
                        }
                    }
                }
            case .updated:
                print("Anchor position updated")
                let entity = anchoredEntities[anchor.id]
                entity?.position = anchor.originFromAnchorTransform.translation
                entity?.orientation = anchor.originFromAnchorTransform.rotation
                entity?.isEnabled = anchor.isTracked
            case .removed:
                print("Anchor position now unknown")
                let entity = anchoredEntities[anchor.id]
                entity?.removeFromParent()
                anchoredEntities.removeValue(forKey: anchor.id)
            }
        }
    }
    
    func removeAnchorWithID(_ uuid: UUID) async {
        do {
            try await worldTracking.removeAnchor(forID: uuid)
        } catch {
            //print("Failed to delete world anchor \(uuid) with error \(error).")
        }
    }
}
