import Foundation

public struct Transform {
    
    public let matrix: Matrix44
    public let inverseMatrix: Matrix44
    
    public init() {
        self.matrix = Matrix44.identity()
        self.inverseMatrix = Matrix44.identity()
    }
    
    public init(matrix: Matrix44, inverseMatrix: Matrix44) {
        self.matrix = matrix
        self.inverseMatrix = inverseMatrix
    }
    
    public var inverse: Transform {
        return Transform(matrix: self.inverseMatrix,
                         inverseMatrix: self.matrix)
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
    
    public static func perspectiveMatrix(near: Number,
                                         far: Number,
                                         fov: Number,
                                         aspect: Number) -> Transform {
        
        let invDenom = 1.0/(far-near)
        let inverseTanAngle = 1.0/atan(deg2rad(fov/2.0))
        
        let persp = Matrix44(x00: inverseTanAngle, x01: 0, x02: 0, x03: 0,
                             x10: 0, x11: inverseTanAngle, x12: 0, x13: 0,
                             x20: 0, x21: 0, x22: far*invDenom, x23: -near*far*invDenom ,
                             x30: 0, x31: 0, x32: 1, x33: 0)
        
        let inverse = invert(persp)
        
        return Transform(matrix: persp, inverseMatrix: inverse!)
        
        
    }
    
    public static func lookAtMatrix(eye: Vector3D,
                                    target: Vector3D,
                                    up: Vector3D) -> Transform {
        
        let zaxis = norm(eye - target)
        let xaxis = norm(cross(up, zaxis))
        let yaxis = cross(zaxis, xaxis)
        
//        let dir = norm(look)
//        let right = cross( dir, norm(up))
//        let newUp = cross(right, dir)
        
        let translation = Matrix44(x00: 1, x01: 0, x02: 0, x03: 0.0,
                                   x10: 0, x11: 1, x12: 0, x13: 0.0,
                                   x20: 0, x21: 0, x22: 1, x23: 0.0,
                                   x30: -eye.x, x31: -eye.y, x32: -eye.z, x33: 1)
        
        let orientation = Matrix44(x00: xaxis.x, x01: yaxis.x, x02: zaxis.x, x03: 0.0,
                                   x10: xaxis.y, x11: yaxis.y, x12: zaxis.y, x13: 0.0,
                                   x20: xaxis.z, x21: yaxis.z, x22: zaxis.z, x23: 0.0,
                                   x30: 0,       x31: 0,       x32: 0,       x33: 1)
        
        let view = transpose(orientation * translation)
        
        let inverse = invert(view)
        
        return Transform(matrix: view, inverseMatrix: inverse!)
        
    }
    
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
    
    public static func rotate(withAngle angle: Number) -> Transform {
        
        let m = Matrix44(x00: 1, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: cos(angle), x12: -sin(angle), x13: 0,
                        x20: 0, x21: sin(angle), x22: cos(angle), x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        return Transform(matrix: m, inverseMatrix: transpose(m))
        
    }
    
    public static func scale(withScale amount: Number) -> Transform {
        
        let m = Matrix44(x00: amount, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: amount, x12: 0, x13: 0,
                        x20: 0, x21: 0, x22: amount, x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
        
        let minv = Matrix44(x00: 1.0/amount, x01: 0, x02: 0, x03: 0,
                         x10: 0, x11: 1.0/amount, x12: 0, x13: 0,
                         x20: 0, x21: 0, x22: 1.0/amount, x23: 0,
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

