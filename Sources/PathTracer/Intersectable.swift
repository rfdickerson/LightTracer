import Foundation

public protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Number?
    
    var objectToWorld: Transform { get set }
    
    var material: Material { get set }
    
}
