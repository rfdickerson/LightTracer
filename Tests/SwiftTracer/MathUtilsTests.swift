//
//  MathUtilsTests.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/17/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import XCTest

@testable import MathUtils

class MathUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVectorMultiply() {
        
        let v1 = Vector3D(x: 1, y: 2, z: 3)
        let m1 = createTransform(withTranslation: Vector3D(x: 3,y: 5,z: 6))
        let m2 = createTransform(withTranslation: Vector3D(x: 3,y: 5,z: 6))
        
        let v2 = m1 * v1
        let v3 = m2 * v2
        
        
        XCTAssertEqual(v2.x, 4)
        XCTAssertEqual(v2.y, 7)
        XCTAssertEqual(v2.z, 9)
        
        XCTAssertEqual(v3.x, 7)
        XCTAssertEqual(v3.y, 12)
        XCTAssertEqual(v3.z, 15)
        
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
        
        let a = Vector3D(x: 1, y: 2, z: 3)
        let b = Vector3D(x: 4, y: -5, z: 6)
        
        // 4 -10 + 18
        
        let product = dot(a,b)
        
        XCTAssertEqual(product, 12)
        
    }
    
    func testNormalize() {
        
        let a = Vector3D(x: 3, y: 4, z: 5)
        
        let na = norm(a)
        
        XCTAssertEqual(na.x*na.x+na.y*na.y+na.z*na.z, 1)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        let m1 = createTransform(withTranslation: Vector3D(x: 3,y: 5,z: 6))
        
        self.measure {
            let _ = determinant(m1)
            // Put the code you want to measure the time of here.
        }
    }
    
}
