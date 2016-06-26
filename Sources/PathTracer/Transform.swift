//
//  Transform.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/25/16.
//
//

import Foundation

public struct Transform {
    
    public let matrix: Matrix44
    public let inverseMatrix: Matrix44
    
    init(matrix: Matrix44, inverseMatrix: Matrix44) {
        self.matrix = matrix
        self.inverseMatrix = inverseMatrix
    }
    
    public var inverse: Transform {
        return Transform(matrix: self.inverseMatrix, inverseMatrix: self.matrix)
    }
    
}

public func * (left: Transform, right: Transform) -> Transform {
 
    let m = left.matrix * right.matrix
    let invM = left.inverseMatrix * right.matrix
    
    return Transform(matrix: m, inverseMatrix: invM)
    
}

public func * (left: Transform, right: Vector3D) -> Vector3D {
    return left.matrix * right
}

extension Transform {
    
    public static func perspectiveMatrix(near: Float, far: Float, fov: Float, aspect: Float) -> Transform {
        
        let invDenom = 1.0/(far-near)
        let inverseTanAngle = 1.0/atan(deg2rad(fov/2.0))
        
        let persp = Matrix44(x00: inverseTanAngle, x01: 0, x02: 0, x03: 0,
                             x10: 0, x11: inverseTanAngle, x12: 0, x13: 0,
                             x20: 0, x21: 0, x22: far*invDenom, x23: -near*far*invDenom ,
                             x30: 0, x31: 0, x32: 1, x33: 0)
        
        let inverse = invert(persp)
        
        return Transform(matrix: persp, inverseMatrix: inverse!)
        
        
    }
    
    public static func lookAtMatrix(pos: Vector3D, look: Vector3D, up: Vector3D) -> Transform {
        
        let dir = norm(look - pos)
        let right = cross( dir, norm(up))
        let newUp = cross(right, dir)
        
        let viewMatrix = Matrix44(x00: right.x, x01: newUp.x, x02: dir.x, x03: pos.x,
                                  x10: right.y, x11: newUp.y, x12: dir.y, x13: pos.y,
                                  x20: right.z, x21: newUp.z, x22: dir.z, x23: pos.z,
                                  x30: 0,       x31: 0,       x32: 0,       x33: 1)
        
        let inverse = invert(viewMatrix)
        
        return Transform(matrix: viewMatrix, inverseMatrix: inverse!)
        
        
    }
    
    /// <#Description#>
    ///
    /// - parameter vector: <#vector description#>
    ///
    /// - returns: <#return value description#>
    public static func translate(delta vector: Vector3D) -> Transform {
        
        let m = Matrix44(x00: 1, x01: 0, x02: 0, x03: vector.x,
                        x10: 0, x11: 1, x12: 0, x13: vector.y,
                        x20: 0, x21: 0, x22: 1, x23: vector.z,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        let minv = Matrix44(x00: 1, x01: 0, x02: 0, x03: -vector.x,
                         x10: 0, x11: 1, x12: 0, x13: -vector.y,
                         x20: 0, x21: 0, x22: 1, x23: -vector.z,
                         x30: 0, x31: 0, x32: 0, x33: 1)
        
        return Transform(matrix: m, inverseMatrix: minv)
        
    }
    
    /**
     Rotate about the x axis
     
     */
    public static func rotate(withAngle angle: Float) -> Transform {
        
        let m = Matrix44(x00: 1, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: cos(angle), x12: -sin(angle), x13: 0,
                        x20: 0, x21: sin(angle), x22: cos(angle), x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        return Transform(matrix: m, inverseMatrix: transpose(m))
        
    }
    
    /**
     Scale by a uniform amount on the x,y,z axis
     */
    public static func scale(withScale amount: Float) -> Transform {
        
        let m = Matrix44(x00: amount, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: amount, x12: 0, x13: 0,
                        x20: 0, x21: 0, x22: amount, x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        let minv = Matrix44(x00: 1/amount, x01: 0, x02: 0, x03: 0,
                         x10: 0, x11: 1/amount, x12: 0, x13: 0,
                         x20: 0, x21: 0, x22: 1/amount, x23: 0,
                         x30: 0, x31: 0, x32: 0, x33: 1)
        
        return Transform(matrix: m, inverseMatrix: minv)
        
    }
    
    public static func scale(withVector amount: Vector3D) -> Transform {
        
        let m = Matrix44(x00: amount.x, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: amount.y, x12: 0, x13: 0,
                        x20: 0, x21: 0, x22: amount.z, x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        let minv = Matrix44(x00: 1/amount.x, x01: 0, x02: 0, x03: 0,
                         x10: 0, x11: 1/amount.y, x12: 0, x13: 0,
                         x20: 0, x21: 0, x22: 1/amount.z, x23: 0,
                         x30: 0, x31: 0, x32: 0, x33: 1)

        return Transform(matrix: m, inverseMatrix: minv)
        
    }

}
