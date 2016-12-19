import Foundation

public struct Material {
    
    /// emission color, typically if a light
    let emission: Color
    
    let diffuseColor: Color
    
    /// specular weight
    let ks: Float
    
    /// diffuse weight
    let kd: Float
    
    /// specular exponent
    let n: Float
    
    public init(emission: Color,
                diffuseColor: Color,
                ks: Float,
                kd: Float,
                n: Float) {
        
        self.emission = emission
        self.diffuseColor = diffuseColor
        self.ks = ks
        self.kd = kd
        self.n = n
        
    }
    
    
}
