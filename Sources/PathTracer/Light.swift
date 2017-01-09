//
//  Light.swift
//  SwiftTracer
//
//  Created by Robert F. Dickerson on 1/8/17.
//
//

import Foundation

public enum LightType {
    case point
}

public struct Light {

    public let position: Vector3D
    
    public let type: LightType
    
    public init(_ x: Number, _ y: Number, _ z: Number) {
        position = Vector3D(x, y, z)
        type = .point
    }
    
}
