//
//  Ray.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/25/16.
//
//

import Foundation

let rayEpsilon: Float = 1e-3

struct Ray {
    let origin: Vector3D
    let direction: Vector3D
    
    var minT: Float
    var maxT: Float
}
