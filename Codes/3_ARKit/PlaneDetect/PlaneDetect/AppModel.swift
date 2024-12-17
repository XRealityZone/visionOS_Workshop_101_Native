//
//  AppModel.swift
//  PlaneDetect
//
//  Created by xuchi on 2024/7/17.
//

import ARKit
import SwiftUI
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
    
    private let session = ARKitSession()
    private let planeDetectionProvider = PlaneDetectionProvider(alignments: [.horizontal, .vertical])

    private var rootEntity = Entity()
    private var entityMap: [UUID: Entity] = [:]
    private var colorMap: [PlaneAnchor.Classification: UIColor] = [:]
    
    init() {
        colorMap[.ceiling] = .blue.withAlphaComponent(0.5)
        colorMap[.wall] = .brown.withAlphaComponent(0.5)
        colorMap[.floor] = .green.withAlphaComponent(0.5)
    }
    
    func setupContentEntity() -> Entity {
        return rootEntity
    }
    
    func runSession() async {
        do {
            if PlaneDetectionProvider.isSupported {
                print("Plane detection supported, ready to start session.")
                try await session.run([planeDetectionProvider])
            } else {
                print("Plane detection not supported")
            }
        } catch {
            print("Run ARKitSession error:", error)
        }
    }
    
    func processPlaneDetectionUpdates() async {
        for await update in planeDetectionProvider.anchorUpdates {
            let planeAnchor = update.anchor
            
            switch update.event {
            case .added, .updated:
                print("Plane added/updated")
                updatePlane(planeAnchor)
            case .removed:
                print("Plane removed")
                removePlane(planeAnchor)
            }
        }
    }
    
    private func updatePlane(_ anchor: PlaneAnchor) {
        guard let color = colorMap[anchor.classification] else {
            // This type not supported
            return
        }
        
        if let entity = entityMap[anchor.id] {
            let planeEntity = entity.findEntity(named: "plane") as! ModelEntity
            planeEntity.model!.mesh = MeshResource.generatePlane(width: anchor.geometry.extent.width, height: anchor.geometry.extent.height)
            planeEntity.transform = Transform(matrix: anchor.geometry.extent.anchorFromExtentTransform)
        } else {
            let entity = Entity()
    
            let material = UnlitMaterial(color: color)
            let planeEntity = ModelEntity(mesh: .generatePlane(width: anchor.geometry.extent.width, height: anchor.geometry.extent.height), materials: [material])
            planeEntity.name = "plane"
            planeEntity.transform = Transform(matrix: anchor.geometry.extent.anchorFromExtentTransform)
            entity.addChild(planeEntity)

            entityMap[anchor.id] = entity
            rootEntity.addChild(entity)
        }
        entityMap[anchor.id]?.transform = Transform(matrix: anchor.originFromAnchorTransform)
    }
    
    private func removePlane(_ anchor: PlaneAnchor) {
        entityMap[anchor.id]?.removeFromParent()
        entityMap.removeValue(forKey: anchor.id)
    }
}
