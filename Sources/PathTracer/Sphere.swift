//
//  Sphere.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/23/16.
//
//

import Foundation

public struct Sphere {
    let center: Vector3D
    let radius: Float
    let radiusSquared: Float
    let material: Material
    
    public init(center: Vector3D, radius: Float, material: Material) {
        self.radiusSquared = radius*radius
        self.center = center
        self.radius = radius
        self.material = material
    }
}

extension Sphere : Intersectable {
    
    /**
     Ray-sphere intersection test
     
     - parameter origin: ray origin
     - parameter direction: ray direction
     - returns: distance from the ray origin to the intersection point
     */
    public func intersect(origin: Vector3D, direction: Vector3D) -> Float? {
        
        // transform ray to object space
        // let transform = Matrix44.createTransform(withTranslation: Vector3D(x: -center.x, y: -center.y, z: -center.z))
        
        // let L = transform * origin
        let L = origin - center
        
        let a = dot(direction, direction)
        let b = 2*dot(direction, L)
        let c = dot(L, L) - radiusSquared
        
        guard let roots = solveQuadratic(a: a, b: b, c: c) else {
            return nil
        }
        
        let t0 = min(roots.0, roots.1)
        let t1 = max(roots.0, roots.1)
        
        if t0<0 && t1<0 {
            return nil
        }
        
        return t0
        
    }
    
}
