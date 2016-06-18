//
//  PathTracer.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/18/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import Foundation


struct Pixel {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    
    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}

struct Camera {
    let fieldOfView: Float
    let aspectRatio: Float
    let position: Vector3D
}


typealias Color = Vector3D

let backgroundColor = Vector3D(x: 0.235294, y: 0.67451, z: 0.843137)
let defaultMaterial = Material(emission: Color(x: 0,y: 0,z: 0), ks: 0.0, kd: 0.1, n: 0)

struct Material {
    
    /// emission color, typically if a light
    let emission: Color
    
    /// specular weight
    let ks: Float
    
    /// diffuse weight
    let kd: Float
    
    /// specular exponent
    let n: Float
    
    
}


//func screenSpaceToWorld(vector: Vector3D) -> Vector3D {
//
//    let width: Float = 480
//    let height: Float = 200
//    let newX = -1 + 2 * vector.x/width
//    let newY = -1 + 2 * vector.y/height
//    return Vector3D(x: newX, y: newY, z: 0)
//
//}

protocol Intersectable {
    
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
}

struct Sphere {
    let center: Vector3D
    let radius: Float
    let radiusSquared: Float
    let material: Material
    
    init(center: Vector3D, radius: Float, material: Material) {
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
    func intersect(origin: Vector3D, direction: Vector3D) -> Float? {
        
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



func castRay(origin: Vector3D, direction: Vector3D, depth: Int, objects: [Sphere]) -> Color {
    
    let illuminance = Color(x: 1.0,y: 0.5, z: 0)
    
    for object in objects {
        
        if object.intersect(origin: origin, direction: direction) != nil {
            
            // illuminance = object.material.emission
            
            return illuminance
            
        }
        
    }
    
    return backgroundColor
    
}

func pixelsToBytes(pixels: [Pixel]) -> [UInt8] {
    
    return pixels.flatMap() { value in
        
        return [value.r, value.g, value.b]
    }
}

func redCanvas(width: Int, height: Int) -> [Pixel] {
    let pixels = [Pixel](repeating: Pixel(r: 128, g: 0, b: 0), count: width*height)
    
    return pixels
}

/**
 Creates an array of screenCoordinates to sample from
 
 - parameter width: width of the pixel surface
 - parameter height: height of the pixel surface
 - returns: an array of the pixels of the surface
 */
func screenCoordinates(width: Int, height: Int) -> [Vector3D] {
    
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
func colorToPixel(color: Color) -> Pixel {
    let r = UInt8(pow(color.x, 2.2)*255)
    let g = UInt8(pow(color.y, 2.2)*255)
    let b = UInt8(pow(color.z, 2.2)*255)
    return Pixel(r: r, g: g, b: b)
}
