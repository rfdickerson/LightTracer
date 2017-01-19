import Foundation


public typealias Number = Double

public struct Vector3D {
    
    public var x, y, z, w: Number
    
    public init(_ x: Number, _ y: Number, _ z: Number, _ w: Number = 1.0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
}

extension Vector3D: Equatable { }

public func mix(a: Number, b: Number, mixAmount: Number) -> Number {
    return a * (1-mixAmount) + b*mixAmount
}

public func + (left: Vector3D, right: Vector3D) -> Vector3D {
    let v = Vector3D(left.x + right.x, left.y + right.y, left.z + right.z, left.w + right.w)
    return (1/v.w) * v
}

public func - (left: Vector3D, right: Vector3D) -> Vector3D {
    let v = Vector3D(left.x - right.x, left.y - right.y, left.z - right.z, left.w + right.w)
    return (1/v.w) * v
}

public func * (left: Vector3D, right: Vector3D) -> Vector3D {
    let v = Vector3D(left.x * right.x, left.y * right.y, left.z * right.z, left.w + right.w)
    return (1/v.w) * v
}

public func == (left: Vector3D, right: Vector3D) -> Bool {
    return (left.x == right.x) && (left.y == right.y) && (left.z == right.z) && (left.w == right.w)
}

public func != (left: Vector3D, right: Vector3D) -> Bool {
    return !(left == right)
}

public func * (left: Number, right: Vector3D) -> Vector3D {
    let nw = left * right.w
    
    let nx = (left * right.x)/nw
    let ny = (left * right.y)/nw
    let nz = (left * right.z)/nw
    return Vector3D(nx, ny, nz, 1)
}


public func dot(_ left: Vector3D, _ right: Vector3D) -> Number {
    return (left.x * right.x) + (left.y * right.y) + (left.z * right.z) + (left.w * right.w)
}

public func cross(_ left: Vector3D, _ right: Vector3D) -> Vector3D {
    return Vector3D(left.y * right.z - left.z * right.y,
                    left.z * right.x - left.x * right.z,
                    left.x * right.y - left.y * right.x,
                    left.w * right.w - left.w * right.w
    )
}


public func magnitude(_ v: Vector3D) -> Number {
    return sqrt(v.x*v.x + v.y*v.y + v.z*v.z + v.w*v.w)
}

public func norm(_ v: Vector3D) -> Vector3D {
    let mag = magnitude(v)
    return Vector3D(v.x/mag, v.y/mag, v.z/mag, v.w/mag)
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
                    clamp(low: low, high: high, value: value.z),
                    clamp(low: low, high: high, value: value.w)
    )
    
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

