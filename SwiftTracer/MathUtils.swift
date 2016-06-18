//
//  Math.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/16/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

struct Vector3D {
    let x: Float
    let y: Float
    let z: Float
}

struct Matrix44 {
    let x00, x01, x02, x03: Float
    let x10, x11, x12, x13: Float
    let x20, x21, x22, x23: Float
    let x30, x31, x32, x33: Float
}

extension Matrix44 {
    static func identity() -> Matrix44 {
        return Matrix44(x00: 1, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: 1, x12: 0, x13: 0,
                        x20: 0, x21: 0, x22: 1, x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
    }
}

func createTransform(withTranslation vector: Vector3D) -> Matrix44 {
    
    return Matrix44(x00: 1, x01: 0, x02: 0, x03: vector.x,
                    x10: 0, x11: 1, x12: 0, x13: vector.y,
                    x20: 0, x21: 0, x22: 1, x23: vector.z,
                    x30: 0, x31: 0, x32: 0, x33: 1)
    
}

func createTransform(withRotation angle: Float) -> Matrix44 {
    
    return Matrix44(x00: 1, x01: 0, x02: 0, x03: 0,
                    x10: 0, x11: cos(angle), x12: -sin(angle), x13: 0,
                    x20: 0, x21: sin(angle), x22: cos(angle), x23: 0,
                    x30: 0, x31: 0, x32: 0, x33: 1)
    
}

func createTransform(withScale amount: Float) -> Matrix44 {
    
    return Matrix44(x00: amount, x01: 0, x02: 0, x03: 0,
                    x10: 0, x11: amount, x12: 0, x13: 0,
                    x20: 0, x21: 0, x22: amount, x23: 0,
                    x30: 0, x31: 0, x32: 0, x33: 1)
    
}


func mix(a: Float, b: Float, mixAmount: Float) -> Float {
    return a * (1-mixAmount) + b*mixAmount
}

func + (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

func - (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
}

func * (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
}

func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}

func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

func * (left: Float, right: Matrix44) -> Matrix44 {
    return Matrix44(x00: left*right.x00, x01: left*right.x01, x02: left*right.x02, x03: left*right.x03,
                    x10: left*right.x10, x11: left*right.x11, x12: left*right.x12, x13: left*right.x13,
                    x20: left*right.x20, x21: left*right.x21, x22: left*right.x22, x23: left*right.x23,
                    x30: left*right.x30, x31: left*right.x31, x32: left*right.x32, x33: left*right.x33)
}

func * (left: Matrix44, right: Vector3D) -> Vector3D {
    let x = left.x00 * right.x + left.x01 * right.y + left.x02 * right.z + left.x03
    let y = left.x10 * right.x + left.x11 * right.y + left.x12 * right.z + left.x13
    let z = left.x20 * right.x + left.x21 * right.y + left.x22 * right.z + left.x23
    let w = left.x30 + left.x31 + left.x32 + left.x33
    
    return Vector3D(x: x/w, y: y/w, z: z/w)
}


/**
 Scalar product of two vectors
 - parameter left: Vector3D
 - parameter right: Vector3D
 - returns: the scalar product of the two vectors
 */
func dot(_ left: Vector3D, _ right: Vector3D) -> Float {
    return (left.x * right.x) + (left.y * right.y) + (left.z * right.z)
}

func cross(_ left: Vector3D, _ right: Vector3D) -> Vector3D {
    return Vector3D(x: left.y * right.z - left.z * right.y,
                    y: left.x * right.z - left.z * right.x,
                    z: left.x * right.y - left.y * right.x
    )
}

func determinant(_ m: Matrix44) -> Float {
    return    m.x00*m.x11*m.x22*m.x33 + m.x00*m.x12*m.x23*m.x31 + m.x00*m.x13*m.x21*m.x32
            + m.x01*m.x10*m.x23*m.x32 + m.x01*m.x12*m.x20*m.x33 + m.x01*m.x13*m.x22*m.x30
            + m.x02*m.x10*m.x21*m.x33 + m.x02*m.x11*m.x23*m.x30 + m.x02*m.x13*m.x20*m.x31
            + m.x03*m.x10*m.x22*m.x31 + m.x03*m.x11*m.x20*m.x32 + m.x03*m.x12*m.x21*m.x30
            - m.x00*m.x11*m.x23*m.x32 - m.x00*m.x12*m.x21*m.x33 - m.x00*m.x13*m.x22*m.x31
            - m.x00*m.x10*m.x22*m.x33 - m.x01*m.x12*m.x23*m.x30 - m.x01*m.x13*m.x20*m.x32
            - m.x02*m.x10*m.x23*m.x31 - m.x02*m.x11*m.x20*m.x33 - m.x02*m.x13*m.x21*m.x30
            - m.x03*m.x10*m.x21*m.x32 - m.x03*m.x11*m.x22*m.x30 - m.x03*m.x12*m.x20*m.x31
}

func invert(_ matrix: Matrix44) -> Matrix44? {
    let det = determinant(matrix)
    if det == 0 {
        return nil
    }
    
    // TODO
    return Matrix44.identity()
    
}


    
func magnitude(_ v: Vector3D) -> Float {
        return sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}
    
func norm(_ v: Vector3D) -> Vector3D {
        let mag = magnitude(v)
        return Vector3D(x: v.x/mag, y: v.y/mag, z: v.z/mag)
}


func deg2rad(degrees: Float) -> Float {
    return degrees * Float(M_PI) / 180
}

func clamp(low: Float, high: Float, value: Float) -> Float {
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
func solveQuadratic(a: Float, b: Float, c: Float) -> (Float, Float)? {
    
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

