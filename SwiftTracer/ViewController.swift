//
//  ViewController.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/12/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var data: [UInt8]? = nil
    
    var objects = [Sphere]()
    
    var callback: CGDataProviderReleaseDataCallback = {_,_,_ in 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let lightMaterial = Material(emission: Color(x: 0.6, y: 0.6, z: 0.6), ks: 0, kd: 0, n: 0)
        
//        for i in 1...5 {
//            objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: Float(-5*i)), radius: 0.3, material: defaultMaterial))
//        }
        
        objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: -5), radius: 0.3, material: defaultMaterial))
        
        // left wall
        // objects.append(Sphere(center: Vector3D(x: -5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))
        
        // objects.append(Sphere(center: Vector3D(x: 5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))
        
        let lightSphere = Sphere(center: Vector3D(x: 2, y: 1, z: 0), radius: 0.5, material: lightMaterial)
        objects.append(lightSphere)
        
        let width = 200
        let height = 400
        let bytesPerPixel = 3
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo()
        
        let bitmapBytesPerRow = (width) * 3
 
        var colors = [Color]()

        
        let cameraToWorld = Matrix44(x00: 0.945519,  x01: 0, x02: -0.325569, x03: 0,
                                     x10: -0.179534, x11: 0.834209, x12: -0.521403, x13: 0,
                                     x20: 0.271593,  x21: 0.551447, x22: 0.78876, x23: 0,
                                     x30: 4.208271, x31: 8.374532, x32: 17.932925, x33: 1);
    
        
        let screenCoords = screenCoordinates(width: width, height: height)
        var origin = Vector3D(x: 0,y: 0, z: 0)
        origin = cameraToWorld*origin
        
        for coord in screenCoords {
            
            let newCoord = cameraToWorld*coord
            var direction = norm(newCoord - origin)
            //direction = cameraToWorld*direction
            direction = norm(direction)
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

