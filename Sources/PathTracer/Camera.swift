//
//  Camera.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/23/16.
//
//

import Foundation

public typealias Transform = Matrix44

public struct Camera {
    
    public let worldToCamera: Transform
    public let cameraToWorld: Transform
    public let clipHither: Float
    public let clipYon: Float
    public let fieldOfView: Float

    public init(worldToCamera: Transform, hither: Float, yon: Float, fieldOfView: Float) {
        
        self.worldToCamera = worldToCamera
        
        let cameraToWorld = invert(worldToCamera)
        
        self.cameraToWorld = cameraToWorld!
        self.clipHither = hither
        self.clipYon = yon
        self.fieldOfView = fieldOfView
        // compute projective camera transformations
    }
    
}

public func perspectiveMatrix(near: Float, far: Float, fov: Float, aspect: Float) -> Matrix44 {
    
    let invDenom = 1.0/(far-near)
    let inverseTanAngle = 1.0/atan(deg2rad(fov/2.0))
    
    let persp = Matrix44(x00: inverseTanAngle, x01: 0, x02: 0, x03: 0,
                         x10: 0, x11: inverseTanAngle, x12: 0, x13: 0,
                         x20: 0, x21: 0, x22: far*invDenom, x23: -near*far*invDenom ,
                         x30: 0, x31: 0, x32: 1, x33: 0)
    return persp
    
    
}

public func lookAtMatrix(pos: Vector3D, look: Vector3D, up: Vector3D) -> Matrix44 {
    
    let dir = norm(look - pos)
    let right = cross( dir, norm(up))
    let newUp = cross(right, dir)
    
    let viewMatrix = Matrix44(x00: right.x, x01: newUp.x, x02: dir.x, x03: pos.x,
                              x10: right.y, x11: newUp.y, x12: dir.y, x13: pos.y,
                              x20: right.z, x21: newUp.z, x22: dir.z, x23: pos.z,
                              x30: 0,       x31: 0,       x32: 0,       x33: 1)
    
    return viewMatrix
    
    
}
