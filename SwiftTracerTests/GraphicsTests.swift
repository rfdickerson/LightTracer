//
//  GraphicsTests.swift
//  SwiftTracer
//
//  Created by Robert Dickerson on 6/17/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//

import XCTest

@testable import SwiftTracer

class GraphicsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScreenSpaceToWorld() {
        
        let coords = screenCoordinates(width: 10, height: 10)
        
        XCTAssertEqual(coords.count, 100)
        
    }
    
    func testRayTo() {
        let v = Vector3D(x: 0, y: 0, z: -1)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
