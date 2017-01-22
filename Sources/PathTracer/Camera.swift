import Foundation


public struct Camera {
    
    public let worldToCamera: Transform
   
    public let clipHither: Float
    
    public let clipYon: Float
    
    public let fieldOfView: Float

    public init(worldToCamera: Transform,
                hither: Float,
                yon: Float,
                fieldOfView: Float) {
        
        self.worldToCamera = worldToCamera
        self.clipHither = hither
        self.clipYon = yon
        self.fieldOfView = fieldOfView
    
    }
    
}


