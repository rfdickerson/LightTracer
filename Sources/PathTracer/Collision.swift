import Foundation

public struct Collision {

    // intersection is a point in world space for ray collision
    public let intersection: Vector3D
    
    public let normal: Vector3D
    
    public let tangent: Vector3D?
    
    public let bitangent: Vector3D?
    
    public let depth: Number
    
}
