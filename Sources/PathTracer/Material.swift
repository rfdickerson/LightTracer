import Foundation

public struct Material {
    
    // name
    let name: String
    
    /// emission color, typically if a light
    let emission: Color
    
    // diffuse lighting color
    let diffuseColor: Color
    
    /// specular weight
    let ks: Number
    
    /// diffuse weight
    let kd: Number
    
    /// specular exponent
    let n: Number
    
    public init(
        name: String,
        emission: Color,
        diffuseColor: Color,
        ks: Number,
        kd: Number,
        n: Number) {
        
        self.name = name
        self.emission = emission
        self.diffuseColor = diffuseColor
        self.ks = ks
        self.kd = kd
        self.n = n
        
    }
    
    
}
