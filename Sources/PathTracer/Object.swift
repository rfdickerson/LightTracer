import Foundation

public protocol Object {
    
    // properties
    
    var id: Int { get set }
    
    var materialName: String { get set }
    
    var objectToWorld: Transform { get set }
    
    // methods
    
    func intersect(ray: Ray) -> Collision?
    
    func normal(at: Vector3D) -> Vector3D
}



