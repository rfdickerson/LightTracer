//
//  PathTracer.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/18/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation

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

public typealias Color = Vector3D

public let backgroundColor = Vector3D(0.235294, 0.67451, 0.843137)

// map values [-1 : 1] to [0 : 1 ]
func normalColor(_ v: Vector3D)->Vector3D {
    return Vector3D((v.x+1)/2, (v.y+1)/2, (v.z+1)/2)
}






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
    
    
    let sampleLight = Vector3D(5, 5, 5)
    // compute the illumination
    
    if let closestObject = closestObject {
        
        let intersection = origin + shortestDepth * direction
        
        let center = closestObject.objectToWorld.matrix * Vector3D(0,0,0)
        
        let normal = norm(center - intersection  )
        
        let lightDirection = norm(intersection - sampleLight)
        
        let illuminance = 0.5*dot(normal, lightDirection) * closestObject.material.diffuseColor
        return illuminance
        
      }
    
    return backgroundColor
    
}

public func cosWeightedRandomHemisphere( n: Vector3D) -> Vector3D {
    let Xi1 = Float(arc4random())/Float(UINT32_MAX)
    let Xi2 = Float(arc4random())/Float(UINT32_MAX)

    let theta = acos(sqrt(1.0-Xi1))
    let phi = 2.0 * Float(M_PI) * Xi2
    
    let xs = sin(theta) * cos(phi)
    let ys = cos(theta)
    let zs = sin(theta) * sin(phi)
    
    var h: Vector3D
    if fabs(n.x) <= fabs(n.y) && fabs(n.x) <= fabs(n.z) {
        h = Vector3D(1.0, n.y, n.z)
    } else if fabs(n.y) <= fabs(n.x) && fabs(n.y) <= fabs(n.z) {
        h = Vector3D(n.x, 1.0, n.z)
    } else {
        h = Vector3D(n.x, n.y, 1.0)
    }
    
    let x = norm(cross(h, n))
    let z = norm(cross(x, n))
    
    let direction =  xs * x + ys * n + zs * z
    return norm(direction)
    
}

public func ppmHeader(width: Int, height: Int, maxValue: Int = 255) -> Data {
    
    return "P6 \(width) \(height) \(maxValue)  \r\n".data(using: String.Encoding.ascii)!
    // return "P6 \(width) \(height) \(maxValue) \r\n".cString(using: String.Encoding.ascii)
    
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
 Creates an array of screenCoordinates to sample from in Raster Space
 0 to width and 0 to height
 
 - parameter width: width of the pixel surface
 - parameter height: height of the pixel surface
 - returns: an array of the pixels of the surface
 */
public func rasterCoordinates(width: Int, height: Int) -> [Vector3D] {
    
    var coords = [Vector3D]()
    
    for j in 0...height-1 {
        for i in 0...width-1 {
            
            let x = Float(i)
            let y = Float(j)
            
            coords.append(Vector3D(x, y, 1.0))
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




