
import Foundation


public final class Scene {
    
    public static let sharedInstance = Scene()
    
    public var objects = [Object]()
    
    public var lights = [Light]()
    
    var materials = [String: Material]()
    
    var currentID = 0
    
    func readVector(_ json: [String:AnyObject]) -> Vector3D? {
        if let x = json["x"] as? Double,
            let y = json["y"] as? Double,
            let z = json["z"] as? Double {
            
            return Vector3D(x,y,z)
            
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
    
    public func load(withJSON: String) throws {
        
        
        let data = try Data(contentsOf: URL(fileURLWithPath: "scene.json"))
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        
        let materialsJSON = json["materials"]
        let objectsJSON = json["objects"] as! [AnyObject]
        
        self.objects = objectsJSON.flatMap { parseObject($0 as! [String: AnyObject]) }
        
        
    }
    
}
