import Foundation

public protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
    
    var objectToWorld: Transform { get set }
    
    var material: Material { get set }
    
}
