//
//  ViewController.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit

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
 */
func screenCoordinates(width: Int, height: Int) -> [Vector3D] {
    
    var coords = [Vector3D]()
    
    for j in 0...height-1 {
        for i in 0...width-1 {
            
            let x = -1 + 2*Float(i)/Float(width)
            let y = -1 + 2*Float(j)/Float(height)
            
            coords.append(Vector3D(x: x, y: y, z: 0))
        }
    }
    
    return coords
}

func colorToPixel(color: Color) -> Pixel {
    let r = UInt8(pow(color.x, 2.2)*255)
    let g = UInt8(pow(color.y, 2.2)*255)
    let b = UInt8(pow(color.z, 2.2)*255)
    
    return Pixel(r: r, g: g, b: b)
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var data: [UInt8]? = nil
    
    var objects = [Sphere]()
    
    
    var callback: CGDataProviderReleaseDataCallback = {_,_,_ in 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaultMaterial = Material(emission: Color(x: 0,y: 0,z: 0), ks: 0.0, kd: 0.1, n: 0)
        // let lightMaterial = Material(emission: Color(x: 0.6, y: 0.6, z: 0.6), ks: 0, kd: 0, n: 0)
        
        objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: -5), radius: 0.01, material: defaultMaterial))
        
        // let lightSphere = Sphere(center: Vector3D(x: 2, y: 1, z: 0), radius: 0.5, material: lightMaterial)
        // objects.append(lightSphere)
        
        let width = 128
        let height = 128
        let bytesPerPixel = 3
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo()
        
        let bitmapBytesPerRow = (width) * 3
        // data = [UInt8](repeating: 128, count: 32*32*8)
    
        // let pixels = redCanvas(width: width, height: height)
        var colors = [Color]()
        // compute over the surface the pixel Color
        
//        let cameraToWorld = Matrix44(x00: 0.945519,  x01: 0, x02: -0.325569, x03: 0,
//                                     x10: -0.179534, x11: 0.834209, x12: -0.521403, x13: 0,
//                                     x20: 0.271593,  x21: 0.551447, x22: 0.78876, x23: 0,
//                                     x30: 4.208271, x31: 8.374532, x32: 17.932925, x33: 1);
    
        
        let screenCoords = screenCoordinates(width: width, height: height)
        let origin = Vector3D(x: 0,y: 0, z: -1)
        
        for coord in screenCoords {
            
            let direction = norm(coord - origin)
            let color = castRay(origin: origin, direction: direction, depth: 0, objects: objects)
            colors.append(color)
        }
        
        let pixels = colors.map(colorToPixel)
        
        let data = pixelsToBytes(pixels: pixels)
        
        let provider = CGDataProvider(dataInfo: nil, data: data,
                                      size: width*height*bytesPerPixel, releaseData: callback)
        
        let cgImage = CGImage(
            width: width, // pixels wide
            height: height, // pixels high
            bitsPerComponent: 8,  // bits per component
            bitsPerPixel: 24, // bits per pixel
            bytesPerRow: bitmapBytesPerRow,  // bytes per row
            space: colorSpace, // color space
            bitmapInfo: bitmapInfo,
            provider: provider!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )
        
        // cgImage
        
        
        imageView.image = UIImage(cgImage: cgImage!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

