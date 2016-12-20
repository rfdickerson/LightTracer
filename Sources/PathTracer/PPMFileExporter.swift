import Foundation

public class PPMFileExporter {
    
    public init() { }

    public func export(image: Image, fileName: String) throws {
        
        let pixels = image.colors.map(colorToPixel)
        
        let data = pixelsToBytes(pixels: pixels)
        
        let ndata = Data(bytes: data)
        
        let header = ppmHeader(width: Int(image.width),
                               height: Int(image.height))
        
        var output = Data()
        
        output.append(header)
        output.append(ndata)
        
        let fileURL = URL(fileURLWithPath: fileName)
        
        try output.write(to: fileURL)
        print("Wrote to image.ppm")
        
    }
    
    
    private func ppmHeader(width: Int, height: Int, maxValue: Int = 255) -> Data {
        
        return "P6 \(width) \(height) \(maxValue)  \r\n".data(using: String.Encoding.ascii)!
        
    }

    
}

