import Foundation


public class Image {

    public let width: Float
    public let height: Float
    // public let bytesPerPixel
    public let aspectRatio: Float
    
    public var colors = [Color]()
    
    public init( width: Float, height: Float) {
        
        self.width = width
        self.height = height
        

        aspectRatio = width / height
        
        
    }
    
}
