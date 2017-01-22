

class RenderSettings {

    static let sharedInstance = RenderSettings()
    
    var useGlobalIllumination: Bool = false
    
    var numGISamples: Int = 16
    
    var numRenderSamples: Int = 10
    
    var maxBounceDepth: Int = 1
    
    var backgroundColor = Vector3D(1.0, 1.0, 1.0)
    
}
