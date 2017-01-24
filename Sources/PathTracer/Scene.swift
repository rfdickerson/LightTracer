
import Foundation


public final class Scene {
    
    public static let sharedInstance = Scene()
    
    public var objects = [Object]()
    
    public var lights = [Light]()
    
    var materials = [String: Material]()
    
    public var camera: Camera?
    
    public var backgroundColor = Vector3D(1,1,1)
    
    var currentID = 0
    
    func readVector(_ json: [String:AnyObject]) -> Vector3D? {
        if let x = json["x"] as? Double,
            let y = json["y"] as? Double,
            let z = json["z"] as? Double {
            
            return Vector3D(x,y,z)
            
        }
        
        return nil
    }
    
    func readColor(_ json: [String:AnyObject]) -> Vector3D? {
        if let r = json["r"] as? Double,
            let g = json["g"] as? Double,
            let b = json["b"] as? Double {
            
            return Vector3D(r,g,b)
            
        }
        
        return nil
    }
    
    func parseObject(_ json: [String: AnyObject]) -> Object? {
        
        let type = json["type"] as! String
        let materialName = json["material"] as! String
        let position = readVector(json["position"] as! [String : AnyObject])
        
        switch type {
        case "sphere":
            let radius = json["radius"] as! Double
            return Sphere(id: currentID,
                          objectToWorld: Transform(),
                          radius: radius,
                          materialName: materialName)
        default:
            break
        }
        
        print("Position is \(position)")
        
        return nil
        
    }
    
    func parseMaterial(_ json: [String: AnyObject]) -> Material? {
        
        let name = json["name"] as! String
        
        let emissionColor = readColor(json["emissionColor"] as! [String: AnyObject]) ?? Vector3D(0,0,0)
        
        let diffuseColor = readColor(json["diffuseColor"] as! [String: AnyObject]) ?? Vector3D(0,0,0)
        
        let kd = (json["kd"] as? Double) ?? 0.0
        
        let ks = (json["ks"] as? Double) ?? 0.0
        
        let n = (json["n"] as? Double) ?? 0.0
        
        return Material(
            name: name,
            emission: emissionColor,
            diffuseColor: diffuseColor,
            ks: ks,
            kd: kd,
            n: n
        )
        
    }
    
    func parseLight(_ json: [String: AnyObject]) -> Light? {
        
        if let type = json["type"] as? String,
            let position = readVector(json["position"] as! [String : AnyObject]),
            let color = readColor(json["color"] as! [String: AnyObject]) {
            
            return Light(position: position, color: color)
            
        } else {
            return nil
        }
        
    }
    
    func parseCamera(_ json: [String: AnyObject]) -> Camera? {
        
        if let position = readVector(json["position"] as! [String : AnyObject]),
            let target = readVector(json["target"] as! [String : AnyObject]),
            let up = readVector(json["up"] as! [String : AnyObject]),
            let near = json["near"] as? Double,
            let far = json["far"] as? Double,
            let fov = json["fov"] as? Double
        {
            
            return Camera(
                position: position,
                target: target,
                up: up,
                near: near,
                far: far,
                fov: fov)
            
        } else {
            return nil
        }
        
        
    }
    
    public func load(withJSON: String) throws {
        
        
        let data = try Data(contentsOf: URL(fileURLWithPath: "scene.json"))
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        
        let materialsJSON = json["materials"] as! [AnyObject]
        let objectsJSON = json["objects"] as! [AnyObject]
        
        self.objects = objectsJSON.flatMap { parseObject($0 as! [String: AnyObject]) }
        
        print("Loaded objects: \(self.objects)")
        
        materialsJSON.flatMap {
            parseMaterial($0 as! [String: AnyObject])
            }.forEach {
                Scene.sharedInstance.materials[$0.name] = $0
        }
        
        print("Loaded materials: \(self.materials)")
        
        if let cameraJSON = json["camera"] as? [String: AnyObject],
            let camera = parseCamera( cameraJSON ) {
            
            self.camera = camera
            
        } else {
            print("Could not create a Camera")
        }
        
        
    }
    
}
