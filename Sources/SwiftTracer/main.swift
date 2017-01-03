import Foundation
import Dispatch

import SimplePNG

import PathTracer

let width = 300
let height = 200
let aspectRatio = Double(width)/Double(height)

print("Swift Monte-Carlo Path Tracing renderer")

var objects = [Intersectable]()

let lightMaterial = Material(emission: Color(0.8, 0.2, 0.2),
                             diffuseColor: Color(0.0, 0.0, 0.0),
                             ks: 0, kd: 0, n: 0)

let redMaterial = Material(emission: Color(0.5 , 0.5, 0.5),
                           diffuseColor: Color(1.0, 0.0, 0.0),
                           ks: 0.0, kd: 1.3, n: 0)

let greenMaterial = Material(emission: Color(0.0 , 0.0, 0.0),
                             diffuseColor: Color(0.0, 0.5, 0.0),
                             ks: 0.0, kd: 0.3, n: 0)

let yellowMaterial = Material(emission: Color(0.5 , 0.5, 0.5),
                              diffuseColor: Color(1.0, 1.0, 0.0),
                              ks: 0.0, kd: 1.3, n: 0)

let whiteMaterial = Material(emission: Color(0.5 , 0.5, 0.5),
                             diffuseColor: Color(1.0, 1.0, 1.0),
                             ks: 0.0, kd: 1.3, n: 0)


for j in 0...6 {
    for i in 0...6 {
        
        let mat = Material(emission: Color(0.4 , 0.4, 0.4),
                           diffuseColor: Color(Number(i+1)/6 + 0.2, Number(j+1)/6 + 0.2, 0.8),
                           ks: 0.0,
                           kd: 0.3,
                           n: 0)
        
        let objectToWorld = Transform.translate(delta: Vector3D(-0.5 + Number(j)/6,
                                                                -0.5 + Number(i)/6,
                                                                5))
        
        objects.append(Sphere(objectToWorld: objectToWorld,
                              radius: 0.050,
                              material: mat))
    }
}

let triangle = Triangle(
                        a: Vector3D(552.8, -20, 20),
                        b: Vector3D(0,     -20, 20),
                        c: Vector3D(0,     -20, 559.2),
                        material: whiteMaterial,
                        objectToWorld: Transform()
)

// objects.append(triangle)

let triangle2 = Triangle(
    a: Vector3D(552.8, -200, 20),
    b: Vector3D(200,     -20, 20),
    c: Vector3D(0,     -20, 559.2),
    material: redMaterial,
    objectToWorld: Transform()
)

objects.append(triangle2)

//let floorMatrix = Transform.translate(delta: Vector3D(0.0, -5000.0, 0.0))
//objects.append(Sphere(  objectToWorld: floorMatrix,
//                        radius: 5000,
//                        material: whiteMaterial))

//let leftMatrix = Transform.translate(delta: Vector3D(-2700.0, 0.0, 0.0))
//objects.append(Sphere(  objectToWorld: leftMatrix,
//                        radius: 5000,
//                        material: yellowMaterial))




let lookAt = Transform.lookAtMatrix(
                            pos:  Vector3D(278.0, 273.0, -800.0),
                            look: Vector3D(0.0,   0.0,    1.0),
                            up:   Vector3D(0.0,   1.0,    0.0))

let perspective = Transform.perspectiveMatrix(
                            near: 0.01,
                            far:  100.0,
                            fov:  55,
                            aspect: aspectRatio)

// converts -1:1 coordinates to 0:300
let screenToRaster = Transform.scale(withVector: Vector3D(
    Number(width), Number(height), 1.0))
    * Transform.scale(withVector: Vector3D(1, 1/aspectRatio, 1))
    * Transform.translate(delta: Vector3D(-Number(width)/2, -Number(height)/2, 0.0))

let rasterToScreen = screenToRaster.inverse

let cameraToScreen = perspective
let screenToCamera = cameraToScreen.inverse

let cameraToWorld = lookAt.inverse
let worldToCamera = cameraToWorld.inverse

let worldToScreen = cameraToScreen * cameraToWorld

//let rasterToCamera = cameraToScreen.inverse * rasterToScreen
let rasterToWorld =  screenToCamera * rasterToScreen

let screenCoords = rasterCoordinates(width: Int(width),
                                     height: Int(height))
var origin = Vector3D(0.0, 0.0, 0.0)

print("Camera to world matrix is \(cameraToWorld)")

let sampleOrigin = cameraToWorld * origin
print("Origin in world space is \(sampleOrigin)")

print("Rendering...")

var bitmap = Bitmap()

for j in 0...height-1 {
    
    var row: [Pixel] = [Pixel]()
    
    for i in 0...width-1 {
        
        let x = Number(i)
        let y = Number(j)
        
        var direction = rasterToWorld * Vector3D(x, y, 1)
        direction = norm(direction)
        
        let ray = Ray(origin: origin,
                      direction: direction)
        
        let color = castRay(ray: ray,
                            bounceDepth: 0,
                            objects: objects)
        
        row.append( Pixel.srgb(Float(color.x), Float(color.y), Float(color.z)))
        
    }
    
    bitmap.append(row)
    
}

var image = Image( width: width,
                   height: height,
                   colorType: ColorType.rgb,
                   bitDepth: 8,
                   bitmap: bitmap
)

do {
    try image.write(to: URL(fileURLWithPath: "image.png"))
} catch {
   print("Could not export the image")
}

