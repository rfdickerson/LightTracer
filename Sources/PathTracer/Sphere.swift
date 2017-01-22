import Foundation

public struct Sphere {
    
    // Intersectable properties
    public var id: Int
    
    public var objectToWorld: Transform
    
    public var materialName: String
    
    public let radius: Number
    
    internal let radiusSquared: Number
    
    public init(id: Int,
                objectToWorld: Transform,
                radius: Number,
                materialName: String) {
        
        self.id = id
        self.objectToWorld = objectToWorld
        self.radiusSquared = radius * radius
        self.radius = radius
        self.materialName = materialName
    }
    
}

extension Sphere : Object {
    
    public func intersect(ray: Ray) -> Collision? {
        
        // transform ray to object space
        let center = objectToWorld * Vector3D(0, 0, 0)
    
        let L = ray.origin - center
        
        let a = dot(ray.direction, ray.direction)
        let b = 2 * dot(ray.direction, L)
        let c = dot(L, L) - radiusSquared
        
        guard let roots = solveQuadratic(a: a, b: b, c: c) else {
            return nil
        }
        
        let t0 = min(roots.0, roots.1)
        let t1 = max(roots.0, roots.1)
        
        if t0<0 && t1<0 {
            return nil
        }
        
        let intersection = ray.origin + t0 * ray.direction
        
        // let center = objectToWorld * Vector3D(0,0,0)
        
        
        return Collision(intersection: intersection, depth: t0, object: self)
        
    }
    
    public func normal(at intersection: Vector3D) -> Vector3D {
        
        let center = objectToWorld * Vector3D(0, 0, 0)
        
        return norm(center - intersection)

    }
    
}
