//
//  TrackingDataTests.swift
//  CameraTrackerEditorTests
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import XCTest
@testable import CameraTrackerEditor

class TrackingDataTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func buildData(numberOfEntries: Int) -> TrackingData {
        let data = TrackingData()
        for _ in 0..<numberOfEntries {
            data.pushEntry(
                deltaTime: 1.0,
                position: (x: 0.0, y: 0.0, z: 0.0),
                rotation: (x: 0.0, y: 0.0, z: 0.0)
            )
        }
        return data
    }
    
    func assertCompareEntries(_ a: TrackingEntry, _ b: TrackingEntry) {
        XCTAssertEqual(a.timeStamp, b.timeStamp, accuracy: 0.0001)
        XCTAssertEqual(a.position.x, b.position.x, accuracy: 0.0001)
        XCTAssertEqual(a.position.y, b.position.y, accuracy: 0.0001)
        XCTAssertEqual(a.position.z, b.position.z, accuracy: 0.0001)
        XCTAssertEqual(a.rotation.x, b.rotation.x, accuracy: 0.0001)
        XCTAssertEqual(a.rotation.y, b.rotation.y, accuracy: 0.0001)
        XCTAssertEqual(a.rotation.z, b.rotation.z, accuracy: 0.0001)
    }
    
    func testIsEmpty() {
        let emptyData = buildData(numberOfEntries: 0)
        let nonEmptyData = buildData(numberOfEntries: 1)
        XCTAssertTrue(emptyData.isEmpty)
        XCTAssertFalse(nonEmptyData.isEmpty)
    }
    
    func testDuration() {
        let emptyData = TrackingData()
        let nonEmptyData = TrackingData()
        let durations = [1.0, 2.3, 0.4, 0.8]
        var total = 0.0
        for d in durations {
            nonEmptyData.pushEntry(
                deltaTime: d,
                position: (x: 0.0, y: 0.0, z: 0.0),
                rotation: (x: 0.0, y: 0.0, z: 0.0)
            )
            total += d
        }
        XCTAssertEqual(emptyData.duration, 0.0)
        XCTAssertEqual(nonEmptyData.duration, total)
    }
    
    func testEmptyDataInterpolation() {
        let emptyData = TrackingData()
        XCTAssertNil(emptyData.getDataAtTime(0.0))
    }
    
    func testNearestNeighborInterpolation1() {
        let data = TrackingData()
        let totalTime = 8.0
        let position = (x: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a)
        let rotation = (x: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a)
        
        data.pushEntry(deltaTime: totalTime, position: position, rotation: rotation)
        for test in NearestNeighborTestFloat1.tests {
            let timeStamp = Double(test.t) * totalTime
            guard let result = data.getDataAtTime(timeStamp, interpolationMethod: InterpolationMethod.NearestNeighbor) else {
                XCTFail("Interpolation returned nil")
                return
            }
            let expected = TrackingEntry(
                timeStamp: timeStamp,
                position: (x: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a),
                rotation: (x: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a)
            )
            assertCompareEntries(
                result,
                expected
            )
        }
    }
    
    func testNearestNeighborInterpolation2() {
        let data = TrackingData()
        let totalTime = 8.0
        data.pushEntry(
            deltaTime: totalTime,
            position: (x: NearestNeighborTestFloat1.a, y: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a),
            rotation: (x: NearestNeighborTestFloat1.a, y: NearestNeighborTestFloat1.a, NearestNeighborTestFloat1.a)
        )
        data.pushEntry(
            deltaTime: 1.0,
            position: (x: NearestNeighborTestFloat1.b, y: NearestNeighborTestFloat1.b, NearestNeighborTestFloat1.b),
            rotation: (x: NearestNeighborTestFloat1.b, y: NearestNeighborTestFloat1.b, NearestNeighborTestFloat1.b)
        )
        for test in NearestNeighborTestFloat1.tests {
            let timeStamp = Double(test.t) * totalTime
            guard let result = data.getDataAtTime(timeStamp, interpolationMethod: InterpolationMethod.NearestNeighbor) else {
                XCTFail("Interpolation returned nil")
                return
            }
            let expected = TrackingEntry(
                timeStamp: timeStamp,
                position: (x: test.result, y: test.result, z: test.result),
                rotation: (x: test.result, y: test.result, z: test.result)
            )
            assertCompareEntries(
                result,
                expected
            )
        }
    }
    
    func testLinearInterpolation1() {
        let data = TrackingData()
        let totalTime = 8.0
        let position = (x: LinearTestFloat1.a, LinearTestFloat2.a, LinearTestFloat3.a)
        let rotation = (x: LinearTestFloat1.a, LinearTestFloat2.a, LinearTestFloat3.a)
        
        data.pushEntry(deltaTime: totalTime, position: position, rotation: rotation)
        for test in LinearTestFloat1.tests {
            let timeStamp = Double(test.t) * totalTime
            guard let result = data.getDataAtTime(timeStamp, interpolationMethod: InterpolationMethod.Linear) else {
                XCTFail("Interpolation returned nil")
                return
            }
            let expected = TrackingEntry(
                timeStamp: timeStamp,
                position: (x: LinearTestFloat1.a, LinearTestFloat2.a, LinearTestFloat3.a),
                rotation: (x: LinearTestFloat1.a, LinearTestFloat2.a, LinearTestFloat3.a)
            )
            assertCompareEntries(
                result,
                expected
            )
        }
    }
    
    func testLinearInterpolation2() {
        let data = TrackingData()
        let totalTime = 8.0
        data.pushEntry(
            deltaTime: totalTime,
            position: (x: LinearTestFloat1.a, y: LinearTestFloat2.a, LinearTestFloat3.a),
            rotation: (x: LinearTestFloat1.a, y: LinearTestFloat2.a, LinearTestFloat3.a)
        )
        data.pushEntry(
            deltaTime: 1.0,
            position: (x: LinearTestFloat1.b, y: LinearTestFloat2.b, LinearTestFloat3.b),
            rotation: (x: LinearTestFloat1.b, y: LinearTestFloat2.b, LinearTestFloat3.b)
        )
        for i in 0..<LinearTestFloat1.tests.count {
            let timeStamp = Double(LinearTestFloat1.tests[i].t) * totalTime
            guard let result = data.getDataAtTime(timeStamp, interpolationMethod: InterpolationMethod.Linear) else {
                XCTFail("Interpolation returned nil")
                return
            }
            let expected = TrackingEntry(
                timeStamp: timeStamp,
                position: (x: LinearTestFloat1.tests[i].result, y: LinearTestFloat2.tests[i].result, z: LinearTestFloat3.tests[i].result),
                rotation: (x: LinearTestFloat1.tests[i].result, y: LinearTestFloat2.tests[i].result, z: LinearTestFloat3.tests[i].result)
            )
            assertCompareEntries(
                result,
                expected
            )
        }
    }
    
    func testCubicInterpolationSingle() {
        let data = TrackingData()
        data.pushEntry(
            deltaTime: SingleEntry.deltaTime,
            position: SingleEntry.entry.position,
            rotation: SingleEntry.entry.rotation
        )
        for test in SingleEntry.tests {
            guard let result = data.getDataAtTime(test, interpolationMethod: InterpolationMethod.Cubic) else {
                XCTFail("Interpolation returned nil")
                return
            }
            let expected = TrackingEntry(
                timeStamp: test,
                position: SingleEntry.entry.position,
                rotation: SingleEntry.entry.rotation
            )
            assertCompareEntries(
                result,
                expected
            )
        }
    }
    
    func testCubicInterpolationDouble() {
        let data = TrackingData()
        for entry in CubicDoubleEntry.entries {
            data.pushEntry(
                deltaTime: entry.deltaTime,
                position: entry.entry.position,
                rotation: entry.entry.rotation
            )
        }
        for test in CubicDoubleEntry.tests {
            guard let result = data.getDataAtTime(test.t, interpolationMethod: InterpolationMethod.Cubic) else {
                XCTFail("Interpolation returned nil")
                return
            }
            assertCompareEntries(
                result,
                test.result
            )
        }
    }
    
    func testCubicInterpolationTriple() {
        let data = TrackingData()
        for entry in CubicTripleEntry.entries {
            data.pushEntry(
                deltaTime: entry.deltaTime,
                position: entry.entry.position,
                rotation: entry.entry.rotation
            )
        }
        for test in CubicTripleEntry.tests {
            guard let result = data.getDataAtTime(test.t, interpolationMethod: InterpolationMethod.Cubic) else {
                XCTFail("Interpolation returned nil")
                return
            }
            assertCompareEntries(
                result,
                test.result
            )
        }
    }
    
    func testCubicInterpolationQuadruple() {
        let data = TrackingData()
        for entry in CubicQuadEntry.entries {
            data.pushEntry(
                deltaTime: entry.deltaTime,
                position: entry.entry.position,
                rotation: entry.entry.rotation
            )
        }
        for test in CubicQuadEntry.tests {
            guard let result = data.getDataAtTime(test.t, interpolationMethod: InterpolationMethod.Cubic) else {
                XCTFail("Interpolation returned nil")
                return
            }
            assertCompareEntries(
                result,
                test.result
            )
        }
    }
}
