//
//  MathUtilitiesTests.swift
//  CameraTrackerEditorTests
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import XCTest
@testable import CameraTrackerEditor

class MathUtilitiesTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func assertCompareVec3(_ a: Vec3, _ b: Vec3) {
        XCTAssertEqual(a.x, b.x, accuracy: 0.0001)
        XCTAssertEqual(a.y, b.y, accuracy: 0.0001)
        XCTAssertEqual(a.z, b.z, accuracy: 0.0001)
    }
    
    func testMin() {
        let a: Vec3 = (x: 0.2, y: 2.0, z: -0.2)
        let b: Vec3 = (x: 2.0, y: -1.1, z: 3.8)
        let result = min(a, b)
        XCTAssertEqual(result.x, 0.2)
        XCTAssertEqual(result.y, -1.1)
        XCTAssertEqual(result.z, -0.2)
    }
    
    func testMax() {
        let a: Vec3 = (x: 0.2, y: 2.0, z: -0.2)
        let b: Vec3 = (x: 2.0, y: -1.1, z: 3.8)
        let result = max(a, b)
        XCTAssertEqual(result.x, 2.0)
        XCTAssertEqual(result.y, 2.0)
        XCTAssertEqual(result.z, 3.8)
    }
    
    func testNearestNeighborInterpolationFloat() {
        for test in NearestNeighborTestFloat1.tests {
            XCTAssertEqual(
                nearestNeighborInterpolation(
                    a: NearestNeighborTestFloat1.a,
                    b: NearestNeighborTestFloat1.b,
                    t: test.t),
                test.result)
        }
    }
    
    func testNearestNeighborInterpolationVec3() {
        let a: Vec3 = (
            x: NearestNeighborTestFloat1.a,
            y: NearestNeighborTestFloat1.a,
            z: NearestNeighborTestFloat1.a
        )
        let b: Vec3 = (
            x: NearestNeighborTestFloat1.b,
            y: NearestNeighborTestFloat1.b,
            z: NearestNeighborTestFloat1.b
        )
        
        for test in NearestNeighborTestFloat1.tests {
            assertCompareVec3(
                nearestNeighborInterpolation(a: a, b: b, t: test.t),
                (x: test.result, y: test.result, z: test.result)
            )
        }
    }
    
    func testLinearInterpolationFloat() {
        for test in LinearTestFloat1.tests {
            XCTAssertEqual(
                linearInterpolation(a: LinearTestFloat1.a, b: LinearTestFloat1.b, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
        
        for test in LinearTestFloat2.tests {
            XCTAssertEqual(
                linearInterpolation(a: LinearTestFloat2.a, b: LinearTestFloat2.b, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
        
        for test in LinearTestFloat3.tests {
            XCTAssertEqual(
                linearInterpolation(a: LinearTestFloat3.a, b: LinearTestFloat3.b, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
    }
    
    func testLinearInterpolationVec3() {
        let a: Vec3 = (
            x: LinearTestFloat1.a,
            y: LinearTestFloat2.a,
            z: LinearTestFloat3.a
        )
        let b: Vec3 = (
            x: LinearTestFloat1.b,
            y: LinearTestFloat2.b,
            z: LinearTestFloat3.b
        )
        
        for i in 0..<LinearTestFloat1.tests.count {
            let result: Vec3 = (
                x: LinearTestFloat1.tests[i].result,
                y: LinearTestFloat2.tests[i].result,
                z: LinearTestFloat3.tests[i].result
            )
            assertCompareVec3(
                linearInterpolation(a: a, b: b, t: LinearTestFloat1.tests[i].t),
                result
            )
        }
    }
    
    func testCubicInterpolationFloat() {
        for test in CubicTestFloat1.tests {
            XCTAssertEqual(
                cubicInterpolation(p: CubicTestFloat1.p, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
        
        for test in CubicTestFloat2.tests {
            XCTAssertEqual(
                cubicInterpolation(p: CubicTestFloat2.p, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
        
        for test in CubicTestFloat3.tests {
            XCTAssertEqual(
                cubicInterpolation(p: CubicTestFloat3.p, t: test.t),
                test.result,
                accuracy: 0.0001)
        }
    }
    
    func testCubicInterpolationVec3() {
        let p: (Vec3, Vec3, Vec3, Vec3) = (
            (x: CubicTestFloat1.p.0, y: CubicTestFloat2.p.0, z: CubicTestFloat3.p.0),
            (x: CubicTestFloat1.p.1, y: CubicTestFloat2.p.1, z: CubicTestFloat3.p.1),
            (x: CubicTestFloat1.p.2, y: CubicTestFloat2.p.2, z: CubicTestFloat3.p.2),
            (x: CubicTestFloat1.p.3, y: CubicTestFloat2.p.3, z: CubicTestFloat3.p.3)
        )
        
        for i in 0..<CubicTestFloat1.tests.count {
            let result: Vec3 = (
                x: CubicTestFloat1.tests[i].result,
                y: CubicTestFloat2.tests[i].result,
                z: CubicTestFloat3.tests[i].result
            )
            assertCompareVec3(
                cubicInterpolation(p: p, t: CubicTestFloat1.tests[i].t),
                result
            )
        }
    }
}
