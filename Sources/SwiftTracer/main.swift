import Foundation
import Dispatch

import SimplePNG

import PathTracer

print("Swift Monte-Carlo Path Tracing renderer")

try Scene.sharedInstance.load(withJSON: "scene.json")



let lookAt = Transform.lookAtMatrix(
    eye:    Vector3D(0.0,   0.0,    7.0),
    target: Vector3D(0.0,   0.0,    0.0),
    up:     Vector3D(0.0,   1.0,    0.0))

let perspective = Transform.perspectiveMatrix(
    near: 0.01,
    far:  100.0,
    fov:  55,
    aspect: aspectRatio)

let screenToRaster = Transform.scale(withVector:
    Vector3D(Number(width), Number(height), 1.0))
    * Transform.scale(withVector: Vector3D(1, 1/aspectRatio, 1))
    * Transform.translate(delta: Vector3D(-Number(width)/2, -Number(height)/2, 0.0))


let rasterToScreen = inverse(screenToRaster)

let cameraToWorld = lookAt

let cameraToScreen = perspective

let worldToRaster = screenToRaster * cameraToScreen * cameraToWorld

let rasterToWorld = inverse( cameraToWorld * cameraToScreen * screenToRaster )

let screenCoords = rasterCoordinates(width: Int(width),
                                     height: Int(height))
var origin = Vector3D(0.0, 0.0, 0.0)

let sampleOrigin = cameraToWorld * origin


func adaptiveSample(x: Number, y: Number, depth: Int) -> Color {
    
    var colorAverage = Color(0,0,0)
    
    var testVertices = [Vector3D]()
    testVertices.append( Vector3D(x-0.5*Number(depth), y-0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x+0.5*Number(depth), y-0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x-0.5*Number(depth), y+0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x+0.5*Number(depth), y+0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x, y, 1) )
    
    for v in testVertices {
        
        let direction = norm( rasterToWorld * v)
        
        let ray = Ray(origin: sampleOrigin,
                      direction: direction)
        
        let color = castRay(ray: ray,
                            bounceDepth: 0,
                            objects: objects)
        
        colorAverage = colorAverage + color
        
    }
    
    colorAverage = (1 / Number(5)) * colorAverage
    
    return colorAverage
    
}

print("Rendering...")

let dispatchQueue = DispatchQueue(label: "renderqueue", attributes: .concurrent)
let dispatchGroup = DispatchGroup()
let semaphore = DispatchSemaphore(value: 1)

var bitmap = Bitmap(repeating: [Pixel](), count: height)

for j in 0...height-1 {
    
    dispatchQueue.async(group: dispatchGroup) {
        
        var row: [Pixel] = [Pixel]()
        
        for i in 0...width-1 {
            
            let x = Number(i)
            let y = Number(j)
            
            let color = adaptiveSample(x: x, y: y, depth: 1)
            
            row.append( Pixel.srgb(Float(color.x), Float(color.y), Float(color.z)))
            
        }
        
        semaphore.wait()
        bitmap[j] = row
        semaphore.signal()
        
    }
    
}



dispatchGroup.wait()

var image = Image( width: width,
                   height: height,
                   colorType: ColorType.rgb,
                   bitDepth: 8,
                   bitmap: bitmap
)

do {
    try image.write(to: URL(fileURLWithPath: "image.png"))
    print("Wrote image to image.png")
} catch {
    print("Could not export the image")
}



