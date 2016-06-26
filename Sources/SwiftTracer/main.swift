import Foundation
import Dispatch

import PathTracer

print("Swift Monte-Carlo Path Tracing renderer")

var objects = [Sphere]()

let lightMaterial = Material(emission: Color(0.8, 0.2, 0.2),
                             diffuseColor: Color(0.0, 0.0, 0.0),
                             ks: 0, kd: 0, n: 0)

let redMaterial = Material(emission: Color(0.0 , 0, 0.0),
                           diffuseColor: Color(1.0, 0.0, 0.0),
                           ks: 0.0, kd: 0.7, n: 0)

let greenMaterial = Material(emission: Color(0.0 , 0.0, 0.0),
                             diffuseColor: Color(0.0, 0.5, 0.0),
                             ks: 0.0, kd: 0.3, n: 0)

let yellowMaterial = Material(emission: Color(0.0 , 0.0, 0.0),
                             diffuseColor: Color(1.0, 1.0, 0.0),
                             ks: 0.0, kd: 0.3, n: 0)


//for j in 0...6 {
//    for i in 0...6 {
//        
//        let mat = Material(emission: Color(0.0 , 0.0, 0.0),
//                                      diffuseColor: Color(Float(i+1)/6, Float(j+1)/6, 0.0),
//                                      ks: 0.0, kd: 0.3, n: 0)
//        
//        objects.append(Sphere(objectToWorld: Vector3D(-0.5 + Float(j)/6, -0.5 + Float(i)/6, 2 ),
//                              radius: 0.020, material: mat))
//    }
//}

// objects.append(Sphere(center: Vector3D(x: 0, y: -100, z: 0), radius: 70, material: greenMaterial))


let objectToWorld = Transform.translate(delta: Vector3D(-2, 0, 10.2))

objects.append(Sphere(objectToWorld: objectToWorld, radius: 2.02, material: greenMaterial))
// objects.append(Sphere(objectToWorld: Vector3D(x: 1, y: 1, z: 6), radius: 1.02, material: redMaterial))

let width: Float = 300 // 1920  // 300
let height: Float = 200 // 1080 // 200
let bytesPerPixel = 3

let bitmapBytesPerRow = (width) * 3

var colors = [Color]()

let aspectRatio = width/height

let lookAt = Transform.lookAtMatrix(pos:  Vector3D(0, 2.00, -1.0),
                          look: Vector3D(0, 0.0, 5),
                          up:   Vector3D(0, 1, 0))

let perspective = Transform.perspectiveMatrix(near: 0.01, far: 100.0, fov: 55,
                                    aspect: Float(height)/Float(width))

// converts -1:1 coordinates to 0:300
let screenToRaster = Transform.scale(withVector: Vector3D(Float(width), Float(height), 1.0))
    * Transform.scale(withVector: Vector3D(1/(2*aspectRatio), 1/2, 1))
    * Transform.translate(delta: Vector3D(1, 1, 0.0))

let cameraToScreen = perspective

let cameraToWorld = lookAt

let worldToScreen = cameraToScreen * cameraToWorld.inverse

let rasterToCamera = cameraToScreen.inverse * screenToRaster
let rasterToWorld = cameraToWorld*cameraToScreen.inverse*screenToRaster.inverse

let screenCoords = rasterCoordinates(width: Int(width), height: Int(height))
var origin = Vector3D(0, 0, 0)

let sampleOrigin = cameraToWorld*origin
print(sampleOrigin)

print("Rendering...")
for coord in screenCoords {
    
    //var direction = coord

    var direction = rasterToWorld*coord
    direction = norm(direction)
    
    let color = castRay(origin: cameraToWorld*origin, direction: direction, bounceDepth: 0, objects: objects)
    colors.append(color)
}

let pixels = colors.map(colorToPixel)

let data = pixelsToBytes(pixels: pixels)

let ndata = Data(bytes: data)
let header = ppmHeader(width: Int(width), height: Int(height))

var output = Data()

output.append(header)
output.append(ndata)

let fileURL = URL(fileURLWithPath: "image.ppm")

do {
    try output.write(to: fileURL)
    print("Wrote to image.ppm")
} catch {
    print("Error writing to image.ppm")
}
