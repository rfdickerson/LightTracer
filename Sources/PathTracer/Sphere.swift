import Foundation

public struct Sphere {
    
    // Intersectable properties
    public var id: Int
    public var objectToWorld: Transform
    public var material: Material
    
    public let radius: Number
    public let radiusSquared: Number
    
    public init(id: Int,
                objectToWorld: Transform,
                radius: Number,
                material: Material) {
        
        self.id = id
        self.objectToWorld = objectToWorld
        self.radiusSquared = radius * radius
        self.radius = radius
        self.material = material
    }
    
}

extension Sphere : Intersectable {
    
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
        
        let normal = norm(center - intersection)
        
        return Collision(intersection: intersection, normal: normal, tangent: nil, bitangent: nil, depth: t0)
        
    }
    
}
