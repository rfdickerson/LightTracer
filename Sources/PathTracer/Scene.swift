//
//  Scene.swift
//  SwiftTracer
//
//  Created by Robert F. Dickerson on 1/8/17.
//
//

import Foundation

public struct Scene {

    static var currentID: Int = 0
    
    var lights: [Light]
    
    var objects: [Intersectable]
    
}
