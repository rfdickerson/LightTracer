import Foundation


public struct Camera {
    
    public let position: Vector3D
    
    public let target: Vector3D
    
    public let up: Vector3D
    
    public let near: Number
    
    public let far: Number
    
    public let fieldOfView: Number
    
    public let aspectRatio: Number
    
    // computed variables
    public let lookAt: Transform
    
    public let perspective: Transform
    
    public let cameraToWorld: Transform
    
    public init(position: Vector3D,
                target: Vector3D,
                up: Vector3D,
                near: Number,
                far: Number,
                fov: Number) {
        
        self.position = position
        self.target = target
        self.up = up
        self.near = near
        self.far = far
        self.fieldOfView = fov
        
        self.aspectRatio = Number(RenderSettings.sharedInstance.height) / Number(RenderSettings.sharedInstance.width)
        
        self.lookAt = Transform.lookAtMatrix(
            eye:  position,
            target: target,
            up:   up)
        
        self.perspective = Transform.perspectiveMatrix(
            near: near,
            far: far,
            fov: fov,
            aspect: aspectRatio
        )
        
        self.cameraToWorld = lookAt * perspective
        
        
    }
    
}


