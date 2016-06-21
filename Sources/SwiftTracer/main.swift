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


for j in 0...6 {
    for i in 0...6 {
        
        let mat = Material(emission: Color(x: 0.0 , y: 0.0, z: 0.0),
                                      diffuseColor: Color(x: Float(i+1)/6, y: Float(j+1)/6, z: 0.2),
                                      ks: 0.0, kd: 0.3, n: 0)
        
        objects.append(Sphere(center: Vector3D(x: Float(j*5)+5, y: Float(i*5)+5, z: 0 ),
                              radius: 1.0, material: mat))
    }
}

//objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: -5), radius: 1.0, material: greenMaterial))
//objects.append(Sphere(center: Vector3D(x: 0, y: 7, z: -5), radius: 1.0, material: redMaterial))
//objects.append(Sphere(center: Vector3D(x: 0, y: 14, z: -5), radius: 1.0, material: yellowMaterial))
//objects.append(Sphere(center: Vector3D(x: 5, y: 0, z: -5), radius: 1.0, material: yellowMaterial))

// left wall
// objects.append(Sphere(center: Vector3D(x: -7000, y: 0, z: -5), radius: 5000, material: greenMaterial))

// objects.append(Sphere(center: Vector3D(x: 5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))

let lightSphere = Sphere(center: Vector3D(x: 0, y: 0, z: 2), radius: 1.0, material: lightMaterial)
//objects.append(lightSphere)

let width = 200
let height = 120
let bytesPerPixel = 3

let bitmapBytesPerRow = (width) * 3

var colors = [Color]()

// let cameraTransform = createTransform(withTranslation: Vector3D(x: 0, y: 0, z: -20))

let lookAt = lookAtMatrix(eye: Vector3D(x: 0, y: 5, z: -5),
                          target: Vector3D(x: 1, y: -2, z: 5),
                          up: Vector3D(x: 0, y: 1, z: 0))

let perspective = perspectiveMatrix(near: 0.01, far: 100.0, fov: 30,
                                    aspect: Float(height)/Float(width))

let cameraToWorld = perspective * lookAt

//let cameraToWorld = Matrix44(x00: 0.945519,  x01: 0, x02: -0.325569, x03: 0,
//                             x10: -0.179534, x11: 0.834209, x12: -0.521403, x13: 0,
//                             x20: 0.271593,  x21: 0.551447, x22: 0.78876, x23: 0,
//                             x30: 4.208271, x31: 8.374532, x32: 17.932925, x33: 1);


let screenCoords = screenCoordinates(width: width, height: height)
var origin = Vector3D(x: 0, y: 0, z: 0)
origin = cameraToWorld*origin


print("Rendering...")
for coord in screenCoords {
    
    let newCoord = cameraToWorld*coord
    var direction = norm(newCoord - origin)

    direction = norm(direction)
    let color = castRay(origin: origin, direction: direction, bounceDepth: 0, objects: objects)
    colors.append(color)
}

//let pixels = redCanvas(width: width, height: height)

let pixels = colors.map(colorToPixel)

let data = pixelsToBytes(pixels: pixels)

let ndata = NSData(bytes: data, length: data.count)
let header = ppmHeader(width: width, height: height)

let output = NSMutableData()

output.append(header!, length: header!.count)
output.append(ndata)

output.write(toFile: "image.ppm", atomically: false)

print("Wrote to image.ppm")
