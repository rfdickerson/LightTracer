//
//  Camera.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/23/16.
//
//

import Foundation


public struct Camera {
    
    public let worldToCamera: Transform
   
    public let clipHither: Float
    public let clipYon: Float
    public let fieldOfView: Float

    public init(worldToCamera: Transform, hither: Float, yon: Float, fieldOfView: Float) {
        
        self.worldToCamera = worldToCamera
        self.clipHither = hither
        self.clipYon = yon
        self.fieldOfView = fieldOfView
        // compute projective camera transformations
    }
    
}


