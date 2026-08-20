//
//  MotionThresholdTests.swift
//  Challenge17 Watch AppTests
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import XCTest
@testable import Challenge17_Watch_App

final class MotionThresholdTests: XCTestCase {
    
    private func sample(pitch: Double = 0, roll: Double = 0, yaw: Double = 0) -> MotionSample {
        MotionSample(
            acceleration: MotionAxisData(x: 0, y: 0, z: 0),
            rotationRate: MotionAxisData(x: 0, y: 0, z: 0),
            attitude: MotionAxisData(x: pitch, y: roll, z: yaw),
            timestamp: 0
        )
    }
    
    func testSmallMovement_returnsNil() {
        let result = MotionThreshold.direction(for: sample(pitch: 0.1, roll: 0.1))
        XCTAssertNil(result)
    }
    
    func testStrongNegativePitch_returnsUp() {
        let result = MotionThreshold.direction(for: sample(pitch: -0.5))
        XCTAssertEqual(result, .up)
    }
    
    func testStrongPositivePitch_returnsDown() {
        let result = MotionThreshold.direction(for: sample(pitch: 0.5))
        XCTAssertEqual(result, .down)
    }
    
    func testStrongPositiveRoll_returnsRight() {
        let result = MotionThreshold.direction(for: sample(roll: 0.5))
        XCTAssertEqual(result, .right)
    }
    
    func testStrongNegativeRoll_returnsLeft() {
        let result = MotionThreshold.direction(for: sample(roll: -0.5))
        XCTAssertEqual(result, .left)
    }
    
    func testDiagonalMovement_returnsNil() {
        let result = MotionThreshold.direction(for: sample(pitch: 0.5, roll: 0.45))
        XCTAssertNil(result)
    }
}
