//
//  MathUtilsTests.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/17/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import XCTest

@testable import PathTracer

class MathUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
        
    func testMatrixMultiply() {
        
        let m1 = Matrix44(x00: 1, x01: 2, x02: 3, x03: 4,
                          x10: 5, x11: 6, x12: 7, x13: 8,
                          x20: 9, x21: 10, x22: 11, x23: 12,
                          x30: 13, x31: 14, x32: 15, x33: 16)
        
        let m2 = Matrix44(x00: 10, x01: 11, x02: 12, x03: 13,
                          x10: 14, x11: 15, x12: 16, x13: 17,
                          x20: 18, x21: 19, x22: 20, x23: 21,
                          x30: 22, x31: 23, x32: 24, x33: 25)
        
        let correct = Matrix44(x00: 180, x01: 190, x02: 200, x03: 210,
                               x10: 436, x11: 462, x12: 488, x13: 514,
                               x20: 692, x21: 734, x22: 776, x23: 818,
                               x30: 948, x31: 1006, x32: 1064, x33: 1122)
        
        let m3 = m1 * m2
        
        XCTAssertEqual(m3, correct)
        
        
    }
    
    func testDotProduct() {
        
        let a = Vector3D(1, 2, 3)
        let b = Vector3D(4, -5, 6)
        
        // 4 -10 + 18
        
        let product = dot(a,b)
        
        XCTAssertEqual(product, 12)
        
    }
    
    func testCrossProduct() {
        
        let a1 = Vector3D(3, -3, 1)
        let b1 = Vector3D(4, 9, 2)
        
        let c1 = cross(a1, b1)
        
        let correct1 = Vector3D(-15, -2, 39)
        XCTAssertEqual(c1, correct1)
        
        let a2 = Vector3D(3, -3, 1)
        let b2 = Vector3D(4, 9, 2)
        
        let c2 = cross(a2, b2)
        let correct2 = Vector3D(-15, -2, 39)
        XCTAssertEqual(c2, correct2)
    }
    
    func testNormalize() {
        
        let a = Vector3D(3, 4, 5)
        
        let na = norm(a)
        
        XCTAssertEqual(na.x*na.x+na.y*na.y+na.z*na.z, 1)
        
    }
    
    func testInverse() {
        
        let B = Matrix44(x00: 1, x01: 0, x02: 0, x03: 1,
                         x10: 0, x11: 2, x12: 1, x13: 2,
                         x20: 2, x21: 1, x22: 0, x23: 1,
                         x30: 2, x31: 0, x32: 1, x33: 4)
        
        let invB = invert(B)
        
        let correctInvB = Matrix44(x00: -2, x01: -1/2, x02: 1, x03: 1/2,
                         x10: 1, x11: 1/2, x12: 0, x13: -1/2,
                         x20: -8, x21: -1, x22: 2, x23: 2,
                         x30: 3, x31: 1/2, x32: -1, x33: -1/2)
        
        XCTAssertEqual(invB, correctInvB)
        
        XCTAssertEqual(B * invB!, Matrix44.identity())
    }
    
    
}
