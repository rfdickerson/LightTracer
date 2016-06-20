import Foundation
import Dispatch

print("Swift Monte-Carlo Path Tracing renderer")

var objects = [Sphere]()

let lightMaterial = Material(emission: Color(x: 0.8, y: 0.2, z: 0.2),
                             diffuseColor: Color(x: 0.0, y: 0.0, z: 0.0),
                             ks: 0, kd: 0, n: 0)

//        for i in 1...5 {
//            objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: Float(-5*i)), radius: 0.3, material: defaultMaterial))
//        }

objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: -5), radius: 0.3, material: redMaterial))

// left wall
objects.append(Sphere(center: Vector3D(x: -5000, y: 0, z: -5), radius: 5000, material: greenMaterial))

// objects.append(Sphere(center: Vector3D(x: 5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))

let lightSphere = Sphere(center: Vector3D(x: 0, y: 0, z: 2), radius: 1.0, material: lightMaterial)
objects.append(lightSphere)

let width = 200
let height = 200
let bytesPerPixel = 3

let bitmapBytesPerRow = (width) * 3

var colors = [Color]()


let cameraToWorld = Matrix44(x00: 0.945519,  x01: 0, x02: -0.325569, x03: 0,
                             x10: -0.179534, x11: 0.834209, x12: -0.521403, x13: 0,
                             x20: 0.271593,  x21: 0.551447, x22: 0.78876, x23: 0,
                             x30: 4.208271, x31: 8.374532, x32: 17.932925, x33: 1);


let screenCoords = screenCoordinates(width: width, height: height)
var origin = Vector3D(x: 0,y: 0, z: 0)
origin = cameraToWorld*origin


print("Rendering...")
for coord in screenCoords {
    
    let newCoord = cameraToWorld*coord
    var direction = norm(newCoord - origin)

    direction = norm(direction)
    let color = castRay(origin: origin, direction: direction, bounceDepth: 0, objects: objects)
    colors.append(color)
}

let pixels = colors.map(colorToPixel)

let data = pixelsToBytes(pixels: pixels)

let ndata = NSData(bytes: data, length: data.count)
let header = ppmHeader(width: width, height: height)

let output = NSMutableData()

output.append(header!, length: header!.count)
output.append(ndata)

output.write(toFile: "image.ppm", atomically: false)

print("Wrote to image.ppm")