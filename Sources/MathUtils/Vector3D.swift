//
//  Math.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/16/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

public struct Vector3D {
    public let x: Float
    public let y: Float
    public let z: Float
    
    public init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
}



public func mix(a: Float, b: Float, mixAmount: Float) -> Float {
    return a * (1-mixAmount) + b*mixAmount
}

public func + (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

public func - (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

public func * (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
}

public func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}

public func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

public func * (left: Float, right: Vector3D) -> Vector3D {
    return Vector3D(x: left * right.x, y: left * right.y, z: left * right.z)
}



/**
 Scalar product of two vectors
 - parameter left: Vector3D
 - parameter right: Vector3D
 - returns: the scalar product of the two vectors
 */
public func dot(_ left: Vector3D, _ right: Vector3D) -> Float {
    return (left.x * right.x) + (left.y * right.y) + (left.z * right.z)
}

public func cross(_ left: Vector3D, _ right: Vector3D) -> Vector3D {
    return Vector3D(x: left.y * right.z - left.z * right.y,
                    y: left.x * right.z - left.z * right.x,
                    z: left.x * right.y - left.y * right.x
    )
}




    
public func magnitude(_ v: Vector3D) -> Float {
        return sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}
    
public func norm(_ v: Vector3D) -> Vector3D {
        let mag = magnitude(v)
        return Vector3D(x: v.x/mag, y: v.y/mag, z: v.z/mag)
}


public func deg2rad(degrees: Float) -> Float {
    return degrees * Float(M_PI) / 180
}

/**
 Clamps the value to a specified range
 
 */
public func clamp(low: Float, high: Float, value: Float) -> Float {
    assert(low < high)
    
    return max(low, min(high, value))
}

/**
 Compute the roots of a quadratic equation
 
 - parameter a: squared term 
 - parameter b: linear term 
 - parameter c: constant term 
 
 - returns: the roots of the solution
 */
public func solveQuadratic(a: Float, b: Float, c: Float) -> (Float, Float)? {
    
    let discriminant = b*b - 4*a*c
    
    if discriminant < 0 {
        return nil
    } else {
        let q = b > 0 ?
            -0.5 * b + sqrt(discriminant) :
            -0.5 * b - sqrt(discriminant)
        
        let x0 = q / a
        let x1 = c / q
        
        return (x0, x1)
        
    }
}

