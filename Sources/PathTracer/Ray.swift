
let rayEpsilon: Number = 1e-6

public struct Ray {
    
    let origin: Vector3D
    let direction: Vector3D
    
    let minT: Number
    let maxT: Number
    
    public init(origin: Vector3D = Vector3D(0,0,0),
         direction: Vector3D = Vector3D(0,0,1),
         minT: Number = 0.1,
         maxT: Number = 1000.0
        ) {
        
        self.origin = origin
        self.direction = direction
        self.minT = minT
        self.maxT = maxT
        
    }
    
}
