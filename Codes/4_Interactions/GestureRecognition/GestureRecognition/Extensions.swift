//
//  Extensions.swift
//  HandTrack
//
//  Created by xuchi on 2024/7/16.
//

import Foundation

extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}
