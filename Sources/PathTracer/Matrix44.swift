import Foundation

public struct Matrix44 {
    let x00, x01, x02, x03: Number
    let x10, x11, x12, x13: Number
    let x20, x21, x22, x23: Number
    let x30, x31, x32, x33: Number
    
    public init(x00: Number, x01: Number, x02: Number, x03: Number,
                x10: Number, x11: Number, x12: Number, x13: Number,
                x20: Number, x21: Number, x22: Number, x23: Number,
                x30: Number, x31: Number, x32: Number, x33: Number) {
        
        self.x00 = x00
        self.x01 = x01
        self.x02 = x02
        self.x03 = x03
        self.x10 = x10
        self.x11 = x11
        self.x12 = x12
        self.x13 = x13
        self.x20 = x20
        self.x21 = x21
        self.x22 = x22
        self.x23 = x23
        self.x30 = x30
        self.x31 = x31
        self.x32 = x32
        self.x33 = x33
        
    }
}

extension Matrix44 : Equatable {}

public func == (lhs: Matrix44, rhs: Matrix44) -> Bool {
    return lhs.x00 == rhs.x00 && lhs.x01 == rhs.x01 && lhs.x02 == rhs.x02 && lhs.x03 == rhs.x03
        && lhs.x10 == rhs.x10 && lhs.x11 == rhs.x11 && lhs.x12 == rhs.x12 && lhs.x13 == rhs.x13
        && lhs.x20 == rhs.x20 && lhs.x21 == rhs.x21 && lhs.x22 == rhs.x22 && lhs.x23 == rhs.x23
        && lhs.x30 == rhs.x30 && lhs.x31 == rhs.x31 && lhs.x32 == rhs.x32 && lhs.x33 == rhs.x33
}

public func != (left: Matrix44, right: Matrix44) -> Bool {
    return !(left == right)
}

extension Matrix44 {
    public static func identity() -> Matrix44 {
        return Matrix44(x00: 1, x01: 0, x02: 0, x03: 0,
                        x10: 0, x11: 1, x12: 0, x13: 0,
                        x20: 0, x21: 0, x22: 1, x23: 0,
                        x30: 0, x31: 0, x32: 0, x33: 1)
    }
    
    
    
    
        
}

/**
 Multiply scalar by a vector
 */
public func * (left: Number, right: Matrix44) -> Matrix44 {
    return Matrix44(x00: left*right.x00, x01: left*right.x01, x02: left*right.x02, x03: left*right.x03,
                    x10: left*right.x10, x11: left*right.x11, x12: left*right.x12, x13: left*right.x13,
                    x20: left*right.x20, x21: left*right.x21, x22: left*right.x22, x23: left*right.x23,
                    x30: left*right.x30, x31: left*right.x31, x32: left*right.x32, x33: left*right.x33)
}

/**
 Multiply a matrix by a vector
 */
public func * (left: Matrix44, right: Vector3D) -> Vector3D {
    let x = left.x00 * right.x + left.x01 * right.y + left.x02 * right.z + left.x03
    let y = left.x10 * right.x + left.x11 * right.y + left.x12 * right.z + left.x13
    let z = left.x20 * right.x + left.x21 * right.y + left.x22 * right.z + left.x23
    let w = left.x30 * right.x + left.x31 * right.y + left.x32 * right.z + left.x33
    
    if w == 1 {
        return Vector3D(x, y, z)
    }
    
    return Vector3D(x/w, y/w, z/w)
}

public func transpose(_ m: Matrix44) -> Matrix44 {
    
    return Matrix44(x00: m.x00, x01: m.x10, x02: m.x20, x03: m.x30,
                    x10: m.x01, x11: m.x11, x12: m.x21, x13: m.x31,
                    x20: m.x02, x21: m.x12, x22: m.x22, x23: m.x32,
                    x30: m.x03, x31: m.x13, x32: m.x23, x33: m.x33)
    
}

/**
 Multiply two matrices together
 */
public func * (left: Matrix44, right: Matrix44) -> Matrix44 {
    let x00 = left.x00*right.x00 + left.x01*right.x10 + left.x02*right.x20 + left.x03*right.x30
    let x10 = left.x10*right.x00 + left.x11*right.x10 + left.x12*right.x20 + left.x13*right.x30
    let x20 = left.x20*right.x00 + left.x21*right.x10 + left.x22*right.x20 + left.x23*right.x30
    let x30 = left.x30*right.x00 + left.x31*right.x10 + left.x32*right.x20 + left.x33*right.x30
    let x01 = left.x00*right.x01 + left.x01*right.x11 + left.x02*right.x21 + left.x03*right.x31
    let x11 = left.x10*right.x01 + left.x11*right.x11 + left.x12*right.x21 + left.x13*right.x31
    let x21 = left.x20*right.x01 + left.x21*right.x11 + left.x22*right.x21 + left.x23*right.x31
    let x31 = left.x30*right.x01 + left.x31*right.x11 + left.x32*right.x21 + left.x33*right.x31
    let x02 = left.x00*right.x02 + left.x01*right.x12 + left.x02*right.x22 + left.x03*right.x32
    let x12 = left.x10*right.x02 + left.x11*right.x12 + left.x12*right.x22 + left.x13*right.x32
    let x22 = left.x20*right.x02 + left.x21*right.x12 + left.x22*right.x22 + left.x23*right.x32
    let x32 = left.x30*right.x02 + left.x31*right.x12 + left.x32*right.x22 + left.x33*right.x32
    let x03 = left.x00*right.x03 + left.x01*right.x13 + left.x02*right.x23 + left.x03*right.x33
    let x13 = left.x10*right.x03 + left.x11*right.x13 + left.x12*right.x23 + left.x13*right.x33
    let x23 = left.x20*right.x03 + left.x21*right.x13 + left.x22*right.x23 + left.x23*right.x33
    let x33 = left.x30*right.x03 + left.x31*right.x13 + left.x32*right.x23 + left.x33*right.x33
    
    return Matrix44(x00: x00, x01: x01, x02: x02, x03: x03,
                    x10: x10, x11: x11, x12: x12, x13: x13,
                    x20: x20, x21: x21, x22: x22, x23: x23,
                    x30: x30, x31: x31, x32: x32, x33: x33)
    
}



