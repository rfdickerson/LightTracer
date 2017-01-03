
public struct Triangle {

    public let v1: Vector3D
    public let v2: Vector3D
    public let v3: Vector3D
    
    public var material: Material
    public var objectToWorld: Transform

    public init(v1: Vector3D, v2: Vector3D, v3: Vector3D,
                material: Material,
                objectToWorld: Transform) {
     
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
        self.material = material
        self.objectToWorld = objectToWorld
        
    }
    
}

extension Triangle: Intersectable {

    public func intersect(ray: Ray) -> Collision? {
        
        let a = objectToWorld * v1
        let b = objectToWorld * v2
        let c = objectToWorld * v3
        
        // find vectors for the edges sharing
        let e1 = b - a
        let e2 = c - a
        
        // begin calculating determinate
        let p = cross(ray.direction, e2)
        let det = dot(e1, p)
        
        // if determinate is near zero, ray lies in plane of triangle or is parallel to plane of triangle
        
        if det > -rayEpsilon && det < rayEpsilon {
            return nil
        }
        
        let invDet = 1.0/det
        
        // calculate distance from v1 to ray origin
        let t = ray.origin - a
        
        // calculate u parameter and test bounds
        let u = dot(t, p) * invDet
        
        // The intersection lies outside of the triangle
        if u < 0.0  || u > 1.0 {
            return nil
        }
        
        // prepare to test v parameter
        let q = cross(t, e1)
        let v = dot(ray.direction, q) * invDet
        
        // the intersection lies outside of the triangle
        if v < 0.0 || u + v > 1.0 {
            return nil
        }
    
        let t2 = dot(e2, q) * invDet
        
        // ray intersects!
        if t2 > rayEpsilon {
            let intersection = ray.origin + t2 * ray.direction
            let normal = cross(e1, e2)
            
            return Collision(intersection: intersection, normal: normal, depth: t2)
        }
        
        return nil
    }
    
}
