

import Foundation
import Dispatch



let maxDepth = Number(5000)

public class PathTracer {
    
    let dispatchQueue = DispatchQueue(label: "renderqueue", attributes: .concurrent)
    
    public init() { }
    
    public func render() {
        
        print("Rendering...")
        
        let height = RenderSettings.sharedInstance.height
        let width = RenderSettings.sharedInstance.width
        
        let dispatchGroup = DispatchGroup()
        
        for j in 0...height-1 {
            
            dispatchQueue.async(group: dispatchGroup) {
                
                for i in 0...width-1 {
                    
                    let x = Number(i)
                    let y = Number(j)
                    
                    let color = adaptiveSample(x: x, y: y, depth: 1)
                    
                    Scene.sharedInstance.film?.setPixel(x: i, y: j, color: color)
                    
                }
                
            }
            
        }
        
        dispatchGroup.wait()
        
               
    }
    
}

func adaptiveSample(x: Number, y: Number, depth: Int) -> Color {
    
    var colorAverage = Color(0,0,0)
    
    var testVertices = [Vector3D]()
    testVertices.append( Vector3D(x-0.5*Number(depth), y-0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x+0.5*Number(depth), y-0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x-0.5*Number(depth), y+0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x+0.5*Number(depth), y+0.5*Number(depth), 1) )
    testVertices.append( Vector3D(x, y, 1) )
    
    let camera = Scene.sharedInstance.camera!
    
    let sampleOrigin = Vector3D(0,0,0)
    
    for v in testVertices {
        
        let direction = norm(camera.rasterToWorld * v)
        
        let ray = Ray(origin: sampleOrigin,
                      direction: direction)
        
        let color = castRay(ray: ray,
                            bounceDepth: 0)
        
        colorAverage = colorAverage + color
        
    }
    
    colorAverage = 1/Number(5) * colorAverage
    
    return colorAverage
    
}

func findClosestCollision(_ ray: Ray) -> Collision? {
    
    var shortestDepth = maxDepth
    
    var closestObject: Object? = nil
    
    var closestCollision: Collision? = nil
    
    Scene.sharedInstance.objects.forEach { object in
        
        if let collision = object.intersect(ray: ray) {
            
            if collision.depth > ray.minT && collision.depth < shortestDepth {
                shortestDepth = collision.depth
                closestCollision = collision
                closestObject = object
            }
            
        }
    }
    
    return closestCollision
    
}


func computeDirectLighting( ray: Ray,
                            closestCollision: Collision,
                            light: Light ) -> Color {
    
    var inShadow = false
    
    let lightDirection = norm(closestCollision.intersection - light.position)
    
    let shadowRay = Ray(origin: closestCollision.intersection,
                        direction: lightDirection,
                        minT: 0,
                        maxT: 1)
    
    for object in Scene.sharedInstance.objects {
        if let _ = object.intersect(ray: shadowRay) {
            inShadow = true
        }
    }
    
    guard let material = Scene.sharedInstance.materials[closestCollision.object.materialName] else {
        fatalError("Could not find material")
    }
    
    // compute direct lighting
    if !inShadow {
        
        let lightDirection = norm(closestCollision.intersection - light.position)
        
        let normal = closestCollision.object.normal(at: closestCollision.intersection)
        
        let lightAngle = max(0, dot( lightDirection, normal)  )
        
        let diffuseIlluminance = lightAngle * material.diffuseColor
        
        let emissionIlluminance = material.emission
        
        return (material.kd * diffuseIlluminance) + emissionIlluminance
    }
    
    return Vector3D(0,0,0)
    
}

public func castRay( ray: Ray,
                     bounceDepth: Int ) -> Color {
    
    if bounceDepth > RenderSettings.sharedInstance.maxBounceDepth {
        return Scene.sharedInstance.backgroundColor
    }
    
    // find closest object
    guard let closestCollision = findClosestCollision(ray) else {
        return Scene.sharedInstance.backgroundColor
    }
    
    var directLighting = Vector3D(0,0,0)
    
    for light in Scene.sharedInstance.lights {
        directLighting = directLighting + computeDirectLighting(ray: ray,
                                                                closestCollision: closestCollision,
                                                                light: light)
    }
    
    return directLighting
    
}


//func adaptiveSample(x: Number, y: Number, depth: Int) -> Color {
//
//    var colorAverage = Color(0,0,0)
//
//    var testVertices = [Vector3D]()
//    testVertices.append( Vector3D(x-0.5*Number(depth), y-0.5*Number(depth), 1) )
//    testVertices.append( Vector3D(x+0.5*Number(depth), y-0.5*Number(depth), 1) )
//    testVertices.append( Vector3D(x-0.5*Number(depth), y+0.5*Number(depth), 1) )
//    testVertices.append( Vector3D(x+0.5*Number(depth), y+0.5*Number(depth), 1) )
//    testVertices.append( Vector3D(x, y, 1) )
//
//    for v in testVertices {
//
//        let direction = norm( rasterToWorld * v)
//
//        let ray = Ray(origin: sampleOrigin,
//                      direction: direction)
//
//        let color = castRay(ray: ray,
//                            bounceDepth: 0)
//
//        colorAverage = colorAverage + color
//
//    }
//
//    colorAverage = (1 / Number(5)) * colorAverage
//
//    return colorAverage
//
//}

public func hemisphere(n: Vector3D) -> Vector3D {
    
    let u1 = drand48()
    let u2 = drand48()
    let r = sqrt(u1)
    let theta = 2 * M_PI * u2
    
    let x = r * cos(theta)
    let y = r * sin(theta)
    
    //    let sx = cosTheta * n.y + sinTheta * (-n.x)
    //    let sy = cosTheta * n.x + sinTheta * n.y
    
    return Vector3D(Number(x), Number(y), Number(sqrt(max(0, 1 - u1))))
    
}


public func cosWeightedRandomHemisphere( n: Vector3D) -> Vector3D {
    
    //let Xi1 = Number(arc4random())/Number(UINT32_MAX)
    //let Xi2 = Number(arc4random())/Number(UINT32_MAX)
    
    let Xi1 = Number(drand48())
    let Xi2 = Number(drand48())
    
    let theta = acos(sqrt(1.0-Xi1))
    let phi = 2.0 * Number(M_PI) * Xi2
    
    let xs = sin(theta) * cos(phi)
    let ys = cos(theta)
    let zs = sin(theta) * sin(phi)
    
    var h: Vector3D
    if fabs(n.x) <= fabs(n.y) && fabs(n.x) <= fabs(n.z) {
        h = Vector3D(1.0, n.y, n.z)
    } else if fabs(n.y) <= fabs(n.x) && fabs(n.y) <= fabs(n.z) {
        h = Vector3D(n.x, 1.0, n.z)
    } else {
        h = Vector3D(n.x, n.y, 1.0)
    }
    
    let x = norm(cross(h, n))
    let z = norm(cross(x, n))
    
    let direction =  xs * x + ys * n + zs * z
    return norm(direction)
    
}






/**
 Creates an array of screenCoordinates to sample from in Raster Space
 0 to width and 0 to height
 
 - parameter width: width of the pixel surface
 - parameter height: height of the pixel surface
 - returns: an array of the pixels of the surface
 */
public func rasterCoordinates(width: Int, height: Int) -> [Vector3D] {
    
    var coords = [Vector3D]()
    
    for j in 0...height-1 {
        for i in 0...width-1 {
            
            let x = Number(i)
            let y = Number(j)
            
            coords.append(Vector3D(x, y, 1.0))
        }
    }
    
    return coords
}






