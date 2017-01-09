//
//  File.swift
//  SwiftTracer
//
//  Created by Robert F. Dickerson on 1/4/17.
//
//

import Foundation


public struct Matrix33 {

    let x00, x01, x02: Number
    let x10, x11, x12: Number
    let x20, x21, x22: Number
    
    public init(x00: Number, x01: Number, x02: Number,
                x10: Number, x11: Number, x12: Number,
                x20: Number, x21: Number, x22: Number) {
        
        self.x00 = x00
        self.x01 = x01
        self.x02 = x02
        self.x10 = x10
        self.x11 = x11
        self.x12 = x12
        self.x20 = x20
        self.x21 = x21
        self.x22 = x22
        
    }
    
    
}

//public func * (left: Matrix33, right: Matrix33) -> Matrix33 {
//    
//    let x00 = left.x00*right.x00 + left.x01*right.x10 + left.x02*right.x20
//    let x10 = left.x10*right.x00 + left.x11*right.x10 + left.x12*right.x20
//    let x20 = left.x20*right.x00 + left.x21*right.x10 + left.x22*right.x20
//    
//    return Matrix33(x00: x00, 
//}
