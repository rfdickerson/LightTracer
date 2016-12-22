import Foundation

public protocol Intersectable {
    
    func intersect(ray: Ray) -> Number?
    
    var objectToWorld: Transform { get set }
    
    var material: Material { get set }
    
}
