import Foundation

public struct Sphere {
    
    // Intersectable properties
    public var objectToWorld: Transform
    public var material: Material
    
    public let radius: Float
    public let radiusSquared: Float
    
    
    public init(objectToWorld: Transform,
                radius: Float,
                material: Material) {
        
        self.objectToWorld = objectToWorld
        self.radiusSquared = radius*radius
        self.radius = radius
        self.material = material
    }
    
}

extension Sphere : Intersectable {
    
    

    
    public func intersect(origin: Vector3D, direction: Vector3D) -> Float? {
        
        // transform ray to object space
        let center = self.objectToWorld.matrix * Vector3D(0, 0, 0)
    
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
