import Foundation
import Dispatch

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
        
        objects.append(Sphere(center: Vector3D(x: -0.5 + Float(j)/6, y: -0.5 + Float(i)/6, z: 0.5 ),
                              radius: 0.020, material: mat))
    }
}

objects.append(Sphere(center: Vector3D(x: 0, y: 0, z: 10.2), radius: 2.02, material: greenMaterial))
//objects.append(Sphere(center: Vector3D(x: 0, y: 0.07, z: 10.2), radius: 1.02, material: redMaterial))
//objects.append(Sphere(center: Vector3D(x: 0, y: 0.14, z: 10.2), radius: 0.02, material: yellowMaterial))


//objects.append(Sphere(center: Vector3D(x: 5, y: 0, z: -5), radius: 1.0, material: yellowMaterial))

// left wall
//objects.append(Sphere(center: Vector3D(x: -7000, y: 0, z: -5), radius: 5000, material: greenMaterial))

// objects.append(Sphere(center: Vector3D(x: 5000, y: 0, z: -5), radius: 5000, material: defaultMaterial))

//let lightSphere = Sphere(center: Vector3D(x: 0, y: 0, z: 5), radius: 1.0, material: lightMaterial)
//objects.append(lightSphere)

let width: Float = 300
let height: Float = 200
let bytesPerPixel = 3

let bitmapBytesPerRow = (width) * 3

var colors = [Color]()

let aspectRatio = width/height

let lookAt = lookAtMatrix(pos:  Vector3D(x: 0, y: 0.00, z: 0.0),
                          look: Vector3D(x: 0, y: 0.51, z: 1),
                          up:   Vector3D(x: 0, y: 1, z: 0))

let perspective = perspectiveMatrix(near: 0.01, far: 100.0, fov: 55,
                                    aspect: Float(height)/Float(width))

// converts -1:1 coordinates to 0:300
let screenToRaster = Matrix44.createTransform(withScale: Vector3D(x: Float(width), y: Float(height), z: 1.0))
    * Matrix44.createTransform(withScale: Vector3D(x: 1/(2*aspectRatio), y: 1/2, z: 1))
    * Matrix44.createTransform(withTranslation: Vector3D(x: 1, y: 1, z: 0.0))

let rasterToScreen = invert(screenToRaster)!

let sample = Vector3D(x: 100, y: 100, z: 0)

let sampleScreen = rasterToScreen * sample

let cameraToScreen = perspective
let screenToCamera = invert(cameraToScreen)!

let cameraToWorld = invert(lookAt)!

//let rasterToCamera = rasterToScreen

// let rasterToWorld = rasterToScreen * screenToCamera * cameraToWorld

//let cameraToWorld = invert(worldToCamera)

// let camera = Camera(worldToCamera: worldToCamera, hither: 0.01, yon: 100.0, fieldOfView: 54 )

let screenCoords = rasterCoordinates(width: Int(width), height: Int(height))
var origin = Vector3D(x: 0, y: 0, z: 0)

print("Rendering...")
for coord in screenCoords {
    
    var direction = coord

    direction = cameraToWorld*screenToCamera*rasterToScreen*direction
    direction = norm(direction)
    
    let color = castRay(origin: origin, direction: direction, bounceDepth: 0, objects: objects)
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