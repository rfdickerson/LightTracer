import Foundation

protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
    
}
