import Foundation

public struct Material {
    
    /// emission color, typically if a light
    let emission: Color
    
    let diffuseColor: Color
    
    /// specular weight
    let ks: Number
    
    /// diffuse weight
    let kd: Number
    
    /// specular exponent
    let n: Number
    
    public init(emission: Color,
                diffuseColor: Color,
                ks: Number,
                kd: Number,
                n: Number) {
        
        self.emission = emission
        self.diffuseColor = diffuseColor
        self.ks = ks
        self.kd = kd
        self.n = n
        
    }
    
    
}
