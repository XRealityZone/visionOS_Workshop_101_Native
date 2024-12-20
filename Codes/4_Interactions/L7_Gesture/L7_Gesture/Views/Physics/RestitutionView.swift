//
//  RestitutionView.swift
//  L7_Gesture
//
//  Created by xuchi on 2024/7/10.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct RestitutionView: View {
    @State private var entity = Entity()
    @State private var balls: [[Entity]] = []
    private let interval: Float = 0.03
    
    // ################ Change this value 8 -> 10 for ideal elastic ################
    private let count = 8
    // #############################################################################
    
    var body: some View {
        RealityView { content in
            for floor in getFloors() {
                entity.addChild(floor)
            }
            
            initBalls()
            for row in balls {
                for ball in row {
                    entity.addChild(ball)
                }
            }
            
            entity.position = [0, 0, 0.3]
            content.add(entity)
        }
        .toolbar {
            ToolbarItem(placement: .bottomOrnament) {
                Button("Gravity", systemImage: "arrow.down") {
                    addGravity(mass: 1)
                }
            }
            
            ToolbarItem(placement: .bottomOrnament) {
                Button("Reset", systemImage: "arrow.counterclockwise") {
                    resetBalls()
                }
            }
        }
    }
    
    func initBalls() {
        if balls.isEmpty {
            for _ in 0...count {
                var row: [Entity] = []
                for i in 0...count {
                    let intensity = getIntensity(i)
                    let ball = ModelEntity(
                        mesh: .generateSphere(radius: 0.01),
                        materials: [SimpleMaterial(color: UIColor(red: 0, green: intensity, blue: 0, alpha: 1), isMetallic: false)],
                        collisionShape: .generateSphere(radius: 0.01),
                        mass: 0
                    )
                    ball.physicsBody?.material = PhysicsMaterialResource.generate(friction: 0.005, restitution: 0.1 * Float(i))
                    row.append(ball)
                }
                balls.append(row)
            }
        }
        resetBalls()
    }
    
    func resetBalls() {
        var z = 0
        for row in balls {
            var idx = 0
            for ball in row {
                ball.position = [-Float(count) / 2 * interval + interval * Float(idx), -0.1, -Float(count) / 2 * interval + interval * Float(z)]
                addGravity(mass: 0)
                idx += 1
            }
            z += 1
        }
    }
    
    private func addGravity(mass: Float) {
        var idx = 0
        for row in balls {
            for ball in row {
                if let ball = ball as? ModelEntity, let _ = ball.physicsBody {
                    ball.physicsBody?.massProperties = PhysicsMassProperties(shape: .generateSphere(radius: 0.01), mass: mass)
                }
                idx += 1
            }
        }
    }
    
    func getFloors() -> [Entity] {
        var floors: [Entity] = []
        for i in 0...count {
            let intensity = getIntensity(i)
            let floor = ModelEntity(
                mesh: .generateBox(width: 0.5, height: 0.01, depth: interval),
                materials: [SimpleMaterial(color: UIColor(red: 0, green: intensity, blue: 0, alpha: 1), isMetallic: false)],
                collisionShape: .generateBox(width: 0.5, height: 0.01, depth: interval),
                mass: 0
            )
            if let _ = floor.physicsBody {
                floor.physicsBody?.material = PhysicsMaterialResource.generate(friction: 0.005, restitution: 0.1 * Float(i))
            }
            floor.position = [0, -0.4, -Float(count) / 2 * interval + interval * Float(i)]
            floors.append(floor)
        }
        return floors
    }
    

    func getIntensity(_ idx: Int) -> Double {
        0.4 + (Double(idx) / Double(count)) * 0.6
    }
}

#Preview {
    RestitutionView()
}
