//
//  AppModel.swift
//  RoomTracking
//
//  Created by xuchi on 2024/7/21.
//

import ARKit
import RealityKit
import SwiftUI
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
    
    // Room tracking
    private let session = ARKitSession()
    private let roomTracking = RoomTrackingProvider()
    private let worldTracking = WorldTrackingProvider()

    private var rootEntity = Entity()
    private var worldAnchors: [UUID: WorldAnchor] = [:]
    private var entitiesBeingAnchored: [UUID: ModelEntity] = [:]
    private var anchoredEntities: [UUID: ModelEntity] = [:]
    
    var setupComplete = false

    func setupContentEntity() -> Entity {
        return rootEntity
    }
    
    func setupCubes() async {
        let cube = ModelEntity(
            mesh: .generateBox(size: 0.1, cornerRadius: 0),
            materials: [SimpleMaterial(color: .gray, isMetallic: false)]
        )
        cube.position = [0, 1.5, -1]
        await attachToWorldAnchor(cube)
        rootEntity.addChild(cube)
    }
    
    func attachToWorldAnchor(_ entity: ModelEntity) async {
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
            if RoomTrackingProvider.isSupported {
                print("Room tracking supported, ready to start session.")
                try await session.run([roomTracking, worldTracking])
                setupComplete = true
            } else {
                print("Room tracking not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processRoomTrackingProcessor() async {
        for await update in roomTracking.anchorUpdates {
            for (id, worldAnchor) in worldAnchors {
                let color: UIColor = isInCurrentRoom(anchor: worldAnchor) ? .green : .red
                anchoredEntities[id]?.model?.materials = 
                    [SimpleMaterial(color: color, roughness: 0.2, isMetallic: true)]
            }
        }
    }
    
    private func isInCurrentRoom(anchor: WorldAnchor) -> Bool {
        guard let currentRoom = roomTracking.currentRoomAnchor else {
            return false
        }
        let position = anchor.originFromAnchorTransform.columns.3.xyz
        return currentRoom.contains(position)
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
