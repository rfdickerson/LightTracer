//
//  Intersectable.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/26/16.
//
//

import Foundation

protocol Intersectable {
    func intersect(origin: Vector3D, direction: Vector3D) -> Float?
}
