//
//  Extensions.swift
//  WorldTrack
//
//  Created by xuchi on 2024/7/17.
//

import RealityKit

extension simd_float4x4 {
    init(translation vector: SIMD3<Float>) {
        self.init(SIMD4<Float>(1, 0, 0, 0),
                  SIMD4<Float>(0, 1, 0, 0),
                  SIMD4<Float>(0, 0, 1, 0),
                  SIMD4<Float>(vector.x, vector.y, vector.z, 1))
    }

    var translation: SIMD3<Float> {
        get {
            columns.3.xyz
        }
        set {
            self.columns.3 = [newValue.x, newValue.y, newValue.z, 1]
        }
    }

    var rotation: simd_quatf {
        simd_quatf(rotationMatrix)
    }

    var xAxis: SIMD3<Float> { columns.0.xyz }

    var yAxis: SIMD3<Float> { columns.1.xyz }

    var zAxis: SIMD3<Float> { columns.2.xyz }

    var rotationMatrix: simd_float3x3 {
        matrix_float3x3(xAxis,
                        yAxis,
                        zAxis)
    }
}

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
