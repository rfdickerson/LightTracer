import Foundation

public protocol Intersectable {
    
    /**
    Returns the intersection point and the normal at that point
    */
    func intersect(ray: Ray) -> (Vector3D, Vector3D)?
    
    var objectToWorld: Transform { get set }
    
    var material: Material { get set }
    
}
