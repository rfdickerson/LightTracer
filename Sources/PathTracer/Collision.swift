import Foundation

public class Collision {

    public let intersection: Vector3D
    
    public let depth: Number
    
    public let object: Object
    
    public init( intersection: Vector3D,
                 depth: Number,
                 object: Object ) {
        
        self.intersection = intersection
        self.depth = depth
        self.object = object
        
    }
    
}
