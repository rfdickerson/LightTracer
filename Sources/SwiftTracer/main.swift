import Foundation
import Dispatch

import MathUtils
import PathTracer

print("Swift Monte-Carlo Path Tracing renderer")

var objects = [Sphere]()

let lightMaterial = Material(emission: Color(x: 0.8, y: 0.2, z: 0.2),
                             diffuseColor: Color(x: 0.0, y: 0.0, z: 0.0),
                             ks: 0, kd: 0, n: 0)

let redMaterial = Material(emission: Color(x: 0.0 , y: 0, z: 0.0),
                           diffuseColor: Color(x: 1.0, y: 0.0, z: 0.0),
                           ks: 0.0, kd: 0.7, n: 0)

let greenMaterial = Material(emission: Color(x: 0.0 , y: 0.0, z: 0.0),
                             diffuseColor: Color(x: 0.0, y: 1.0, z: 0.0),
                             ks: 0.0, kd: 0.3, n: 0)

let yellowMaterial = Material(emission: Color(x: 0.0 , y: 0.0, z: 0.0),
                             diffuseColor: Color(x: 1.0, y: 1.0, z: 0.0),
                             ks: 0.0, kd: 0.3, n: 0)


//for j in 0...6 {
//    for i in 0...6 {
//        
//        let mat = Material(emission: Color(x: 0.0 , y: 0.0, z: 0.0),
//                                      diffuseColor: Color(x: Float(i+1)/6, y: Float(j+1)/6, z: 0.2),
//                                      ks: 0.0, kd: 0.3, n: 0)
//        
//        objects.append(Sphere(center: Vector3D(x: Float(j*5)+5, y: Float(i*5)+5, z: 0 ),
//                              radius: 2.0, material: mat))
//    }
//}

objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: 5), radius: 2.0, material: greenMaterial))
objects.append(Sphere(center: Vector3D(x: 2, y: 7, z: 5), radius: 2.0, material: redMaterial))
objects.append(Sphere(center: Vector3D(x: 0, y: 14, z: 5), radius: 1.0, material: yellowMaterial))
//objects.append(Sphere(center: Vector3D(x: 5, y: 0, z: -5), radius: 1.0, material: yellowMaterial))

// left wall
//objects.append(Sphere(center: Vector3D(x: -7000, y: 0, z: -5), radius: 5000, material: greenMaterial))

// objects.append(Sphere(center: Vector3D(x: 5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))

let lightSphere = Sphere(center: Vector3D(x: 0, y: 0, z: 2), radius: 1.0, material: lightMaterial)
//objects.append(lightSphere)

let width = 200
let height = 200
let bytesPerPixel = 3

let bitmapBytesPerRow = (width) * 3

var colors = [Color]()

let lookAt = lookAtMatrix(pos:  Vector3D(x: 0, y: 0, z: 0),
                          look: Vector3D(x: 0, y: 0, z: 1),
                          up:   Vector3D(x: 0, y: 1, z: 0))

let perspective = perspectiveMatrix(near: 0.1, far: 100.0, fov: 40,
                                    aspect: Float(height)/Float(width))

let cameraToWorld = perspective * lookAt

let screenCoords = screenCoordinates(width: width, height: height)
var origin = Vector3D(x: 0, y: 0, z: 0)
//origin = origin

print("Rendering...")
for coord in screenCoords {
    
    //let newCoord = cameraToWorld*coord
    var direction = norm(coord - origin)

    direction = cameraToWorld*direction
    direction = norm(direction)
    
    let color = castRay(origin: origin, direction: direction, bounceDepth: 0, objects: objects)
    colors.append(color)
}

//let pixels = redCanvas(width: width, height: height)

let pixels = colors.map(colorToPixel)

let data = pixelsToBytes(pixels: pixels)

let ndata = Data(bytes: data)
let header = ppmHeader(width: width, height: height)

var output = Data()

output.append(header)
output.append(ndata)

let fileURL = URL(fileURLWithPath: "image.ppm")

do {
    try output.write(to: fileURL)

    print("Wrote to image.ppm")
} catch {
    
}
