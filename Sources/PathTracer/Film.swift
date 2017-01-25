
import Foundation

import SimplePNG

public struct Film {
    
    let height: Int
    
    let width: Int
    
    let aspectRatio: Number
    
    let screenToRaster: Transform
    
    let semaphore = DispatchSemaphore(value: 1)
    
    var bitmap: Bitmap
    
    public init(width: Int, height: Int, filename: String) {
        
        self.width = width
        self.height = height
        self.aspectRatio = Number(width)/Number(height)
        
        screenToRaster = Transform.scale(withVector:
            Vector3D(Number(width), Number(height), 1.0))
            * Transform.scale(withVector: Vector3D(1, 1/aspectRatio, 1))
            * Transform.translate(delta: Vector3D(-Number(width)/2, -Number(height)/2, 0.0))
        
        bitmap = Bitmap(repeating: [Pixel](repeating: Pixel.srgb(0, 0, 0), count: width), count: height)
    
        
    }
    
    public func setPixel(x: Int, y: Int, color: Color) {
        
        semaphore.wait()
        var row = bitmap[y]
        row[x] = Pixel.srgb(Float(color.x), Float(color.y), Float(color.z))
        semaphore.signal()
        
    }
    
    public func write() {
      
        let image = Image( width: width,
                           height: height,
                           colorType: ColorType.rgb,
                           bitDepth: 8,
                           bitmap: bitmap
        )
        
        do {
            try image.write(to: URL(fileURLWithPath: "image.png"))
            print("Wrote image to image.png")
        } catch {
            print("Could not export the image")
        }

        
    }
    
    
    
}
