import Foundation

public protocol Intersectable {
    
    var id: Int { get set }
    
    func intersect(ray: Ray) -> Collision?
    
    var objectToWorld: Transform { get set }
    
    var material: Material { get set }
    
}



