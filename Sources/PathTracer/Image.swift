import Foundation


public class Image {

    public let width: Number
    public let height: Number
    // public let bytesPerPixel
    public let aspectRatio: Number
    
    public var colors = [Color]()
    
    public init( width: Number, height: Number) {
        
        self.width = width
        self.height = height
        

        aspectRatio = width / height
        
        
    }
    
}
