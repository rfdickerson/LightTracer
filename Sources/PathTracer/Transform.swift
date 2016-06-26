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
    public let inverse: Matrix44?
    
    init(m: Matrix44) {
        matrix = m
        inverse = invert(m)
    }
    
}

