//
//  PathTracer.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/18/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

import MathUtils

public struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}

public struct Camera {
    let fieldOfView: Float
    let aspectRatio: Float
    let position: Vector3D
}


public typealias Color = Vector3D

public let backgroundColor = Vector3D(x: 0.235294, y: 0.67451, z: 0.843137)

// map values [-1 : 1] to [0 : 1 ]
func normalColor(_ v: Vector3D)->Vector3D {
    return Vector3D(x: (v.x+1)/2, y: (v.y+1)/2, z: (v.z+1)/2)
}

public struct Material {
    
    /// emission color, typically if a light
    let emission: Color
    
    let diffuseColor: Color
    
    /// specular weight
    let ks: Float
    
    /// diffuse weight
    let kd: Float
    
    /// specular exponent
    let n: Float
    
    public init(emission: Color, diffuseColor: Color,
                ks: Float, kd: Float, n: Float) {
        self.emission = emission
        self.diffuseColor = diffuseColor
        self.ks = ks
        self.kd = kd
        self.n = n
        
    }
    
    
}

protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
}

public struct Sphere {
    let center: Vector3D
    let radius: Float
    let radiusSquared: Float
    let material: Material
    
    public init(center: Vector3D, radius: Float, material: Material) {
        self.radiusSquared = radius*radius
        self.center = center
        self.radius = radius
        self.material = material
    }
}

extension Sphere : Intersectable {
    
    /**
     Ray-sphere intersection test
     
     - parameter origin: ray origin
     - parameter direction: ray direction
     - returns: distance from the ray origin to the intersection point
     */
    public func intersect(origin: Vector3D, direction: Vector3D) -> Float? {
        
        let L = origin - center
        let a = dot(direction, direction)
        let b = 2*dot(direction, L)
        let c = dot(L, L) - radiusSquared
        
        guard let roots = solveQuadratic(a: a, b: b, c: c) else {
            return nil
        }
        
        let t0 = min(roots.0, roots.1)
        let t1 = max(roots.0, roots.1)
        
        if t0<0 && t1<0 {
            return nil
        }
        
        return t0
        
    }
    
}



//func createRay(start: Vector3D, viewPlane: Vector3D ) -> Vector3D {
//
//}



public func castRay(origin: Vector3D, direction: Vector3D, bounceDepth: Int, objects: [Sphere]) -> Color {
    
    // var illuminance = Color(x: 0.0, y: 0.0, z: 0.0)
    
    if bounceDepth > 1 { return backgroundColor }
    
    // find the closest object
    
    var shortestDepth: Float = 50000
    var closestObject: Sphere? = nil
    
    for object in objects {
        
        if let depth = object.intersect(origin: origin, direction: direction) {
            
            if depth < shortestDepth {
                shortestDepth = depth
                closestObject = object
            }
       
        }
        
    }
    
    // compute the illumination
    
    if let closestObject = closestObject {
        
        let intersection = origin + shortestDepth * direction
        let normal = norm(intersection - closestObject.center)
        
        return closestObject.material.diffuseColor
        
//        for _ in 0...20 {
//            
//            // compute normal at intersection point
//            // trace another ray from intersection point to a random selection of
//            // points in a hemisphere
//
//            
//            let rn = 2*Float(M_PI)*Float(arc4random())/Float(UINT32_MAX)
//            // let rphi = Float(M_PI)*Float(arc4random())/Float(UINT32_MAX)
//            
//            
//            let randomVector = createTransform(withRotation: rn) * Vector3D(x: 0, y: 1, z: 0)
//            //let randomVector = Vector3D(x: cos(rn), y: sin(rphi), z: 0)
//            let r = norm(normal + randomVector)
//            
//            
//            let bounceColor = castRay(origin: intersection, direction: r,
//                                      bounceDepth: bounceDepth + 1, objects: objects)
//            
//            illuminance = illuminance + dot(normal, r) * bounceColor
//            
//        }
        
        
        // illuminance = normalColor(normal)
        
//        return closestObject.material.emission + (1/20) * illuminance

    }
    
    return backgroundColor
    
}

public func ppmHeader(width: Int, height: Int, maxValue: Int = 255) -> [CChar]? {
    
    return "P6 \(width) \(height) \(maxValue) \r\n".cString(using: NSASCIIStringEncoding)
    
}

public func pixelsToBytes(pixels: [Pixel]) -> [UInt8] {
    
    return pixels.flatMap() { value in
        
        return [value.r, value.g, value.b]
    }
}

public func redCanvas(width: Int, height: Int) -> [Pixel] {
    let pixels = [Pixel](repeating: Pixel(r: 128, g: 0, b: 0), count: width*height)
    
    return pixels
}

/**
 Creates an array of screenCoordinates to sample from
 
 - parameter width: width of the pixel surface
 - parameter height: height of the pixel surface
 - returns: an array of the pixels of the surface
 */
public func screenCoordinates(width: Int, height: Int) -> [Vector3D] {
    
    var coords = [Vector3D]()
    
    for j in 0...height-1 {
        for i in 0...width-1 {
            
            let x = -1 + 2*Float(i)/Float(width)
            let y = -1 + 2*Float(j)/Float(height)
            
            coords.append(Vector3D(x: x, y: y, z: -1))
        }
    }
    
    return coords
}

/**
 Converts a color sample to a pixel representation
 applies gamma correction
 
 - parameter color: Color structure
 - returns: a 24-bit Pixel
 */
public func colorToPixel(color: Color) -> Pixel {
    let r = clamp(low: 0, high: 1, value: pow(color.x, 2.2))
    let g = clamp(low: 0, high: 1, value: pow(color.y, 2.2))
    let b = clamp(low: 0, high: 1, value: pow(color.z, 2.2))
    return Pixel(r: UInt8(r*255), g: UInt8(g*255), b: UInt8(b*255))
}


public func perspectiveMatrix(near: Float, far: Float, fov: Float, aspect: Float) -> Matrix44 {
    
    let right = near * atan(deg2rad(degrees: fov) * 0.5)
    let top = right/aspect
    
    return Matrix44(x00: near/right, x01: 0, x02: 0, x03: 0,
                    x10: 0, x11: near/top, x12: 0, x13: 0,
                    x20: 0, x21: 0, x22: -(far + near) / (far - near), x23: -(2 * far * near) / (far - near),
                    x30: 0, x31: 0, x32: -1, x33: 0)
    
}

public func lookAtMatrix(eye: Vector3D, target: Vector3D, up: Vector3D) -> Matrix44 {

    let zaxis = norm(eye - target)
    let xaxis = norm(cross( up, zaxis))
    let yaxis = norm(cross(zaxis, xaxis))

    let translation = createTransform(withTranslation: Vector3D(x: -eye.x, y: -eye.y, z: -eye.z))
    
    let viewMatrix = Matrix44(x00: xaxis.x, x01: xaxis.y, x02: xaxis.z, x03: 0,
                              x10: yaxis.x, x11: yaxis.y, x12: yaxis.z, x13: 0,
                              x20: zaxis.x, x21: zaxis.y, x22: zaxis.z, x23: 0,
                              x30: 0, x31: 0, x32: 0, x33: 1)
    
    return transpose(viewMatrix) * translation

    
}
