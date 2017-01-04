import Foundation


public typealias Number = Double

public struct Vector3D {
    
    public let x: Number
    public let y: Number
    public let z: Number
    
    public init(_ x: Number, _ y: Number, _ z: Number) {
        self.x = x
        self.y = y
        self.z = z
    }
    
}

extension Vector3D: Equatable { }

public func mix(a: Number, b: Number, mixAmount: Number) -> Number {
    return a * (1-mixAmount) + b*mixAmount
}

public func + (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(left.x + right.x, left.y + right.y, left.z + right.z)
}

public func - (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(left.x - right.x, left.y - right.y, left.z - right.z)
}

public func * (left: Vector3D, right: Vector3D) -> Vector3D {
    return Vector3D(left.x * right.x, left.y * right.y, left.z * right.z)
}

public func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z)
}

public func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

public func * (left: Number, right: Vector3D) -> Vector3D {
    return Vector3D(left * right.x, left * right.y, left * right.z)
}


public func dot(_ left: Vector3D, _ right: Vector3D) -> Number {
    return (left.x * right.x) + (left.y * right.y) + (left.z * right.z)
}

public func cross(_ left: Vector3D, _ right: Vector3D) -> Vector3D {
    return Vector3D(left.y * right.z - left.z * right.y,
                    left.z * right.x - left.x * right.z,
                    left.x * right.y - left.y * right.x
    )
}


public func magnitude(_ v: Vector3D) -> Number {
    return sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}

public func norm(_ v: Vector3D) -> Vector3D {
    let mag = magnitude(v)
    return Vector3D(v.x/mag, v.y/mag, v.z/mag)
}


public func deg2rad(_ degrees: Number) -> Number {
    return degrees * (Number(M_PI) / 180.0)
}

public func degrees(_ radians: Number) -> Number {
    return (180.0/Number(M_PI)) * radians
}

public func clamp(low: Number, high: Number, value: Number) -> Number {
    assert(low < high)
    
    return max(low, min(high, value))
}

public func clamp(low: Number, high: Number, value: Vector3D) -> Vector3D {
 
    return Vector3D(clamp(low: low, high: high, value: value.x),
                    clamp(low: low, high: high, value: value.y),
                    clamp(low: low, high: high, value: value.z))
    
}

public func solveQuadratic(a: Number, b: Number, c: Number) -> (Number, Number)? {
    
    let discriminant = b*b - 4 * a * c
    
    if discriminant < 0 {
        return nil
    } else {
        let q = b > 0 ?
            -0.5 * b + sqrt(discriminant) :
            -0.5 * b - sqrt(discriminant)
        
        let x0 = q / a
        let x1 = c / q
        
        return (x0, x1)
        
    }
}

