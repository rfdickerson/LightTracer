import Foundation
import Dispatch


public typealias Color = Vector3D

public let backgroundColor = Vector3D(0.1, 0.1, 0.1)

// map values [-1 : 1] to [0 : 1 ]
func normalColor(_ v: Vector3D ) -> Vector3D {
    return Vector3D((v.x+1)/2, (v.y+1)/2, (v.z+1)/2)
}


public func castRay(ray: Ray,
                    bounceDepth: Int,
                    objects: [Intersectable]) -> Color {
    
    // var illuminance = Color(x: 0.0, y: 0.0, z: 0.0)
    
    if bounceDepth > 1 { return backgroundColor }
    
    // find the closest object
    
    var shortestDepth = 50000.0
    var closestObject: Intersectable? = nil
    
    for object in objects {
        
        if let depth = object.intersect(ray: ray) {
            
            if depth < shortestDepth {
                shortestDepth = depth
                closestObject = object
            }
       
        }
        
    }
    
    
    let sampleLight = Vector3D(343.0, 548.8, 227.0)
    // compute the illumination
    
    if let closestObject = closestObject {
        
        let intersection = ray.origin + shortestDepth * ray.direction
        
        let center = closestObject.objectToWorld * Vector3D(0,0,0)
        
        let normal = norm(center - intersection  )
        
        let lightDirection = norm(intersection - sampleLight)
        
        let lightAngle = clamp(low: 0, high: 1, value: dot( lightDirection, normal ) )
        
        let material = closestObject.material
        
        // print(lightAngle)
        
        let diffuseIlluminance = lightAngle * material.diffuseColor
        let emissionIlluminance = material.emission
        
        return normalColor( normal )
        
        return (material.kd * diffuseIlluminance) + emissionIlluminance
        
      }
    
    return backgroundColor
    
}

//public func cosWeightedRandomHemisphere( n: Vector3D) -> Vector3D {
//    
//    let Xi1 = Float(arc4random())/Float(UINT32_MAX)
//    let Xi2 = Float(arc4random())/Float(UINT32_MAX)
//
//    let theta = acos(sqrt(1.0-Xi1))
//    let phi = 2.0 * Number(M_PI) * Xi2
//    
//    let xs = sin(theta) * cos(phi)
//    let ys = cos(theta)
//    let zs = sin(theta) * sin(phi)
//    
//    var h: Vector3D
//    if fabs(n.x) <= fabs(n.y) && fabs(n.x) <= fabs(n.z) {
//        h = Vector3D(1.0, n.y, n.z)
//    } else if fabs(n.y) <= fabs(n.x) && fabs(n.y) <= fabs(n.z) {
//        h = Vector3D(n.x, 1.0, n.z)
//    } else {
//        h = Vector3D(n.x, n.y, 1.0)
//    }
//    
//    let x = norm(cross(h, n))
//    let z = norm(cross(x, n))
//    
//    let direction =  xs * x + ys * n + zs * z
//    return norm(direction)
//    
//}






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






