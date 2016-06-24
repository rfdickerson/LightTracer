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

public let backgroundColor = Vector3D(x: 0.235294, y: 0.67451, z: 0.843137)

// map values [-1 : 1] to [0 : 1 ]
func normalColor(_ v: Vector3D)->Vector3D {
    return Vector3D(x: (v.x+1)/2, y: (v.y+1)/2, z: (v.z+1)/2)
}



protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
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
    
    // compute the illumination
    
    if let closestObject = closestObject {
        
        let intersection = origin + shortestDepth * direction
        let normal = norm(intersection - closestObject.center)
        
        return normalColor(normal)
        
        // return closestObject.material.diffuseColor
        
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
            
            coords.append(Vector3D(x: x, y: y, z: 0.0))
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




