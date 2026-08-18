//
//  MotionThresholdTests.swift
//  Challenge17 Watch AppTests
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import XCTest
@testable import Challenge17_Watch_App

final class MotionThresholdTests: XCTestCase {
    
    private func sample(ax: Double = 0, ay: Double = 0, az: Double = 0,
                        rx: Double = 0, ry: Double = 0, rz: Double = 0) -> MotionSample {
        MotionSample(
            acceleration: MotionAxisData(x: ax, y: ay, z: az),
            rotationRate: MotionAxisData(x: rx, y: ry, z: rz),
            timestamp: 0
        )
    }
    
    func testSmallMovement_returnsNil() {
        let result = MotionThreshold.direction(for: sample(ax: 0.1, ay: 0.1, rx: 0.1, ry: 0.1))
        XCTAssertNil(result)
    }
    
    func testStrongNegativeYAcceleration_returnsUp() {
        let result = MotionThreshold.direction(for: sample(ay: -0.8))
        XCTAssertEqual(result, .up)
    }
    
    func testStrongPositiveYAcceleration_returnsDown() {
        let result = MotionThreshold.direction(for: sample(ay: 0.8))
        XCTAssertEqual(result, .down)
    }
    
    func testStrongPositiveXAcceleration_returnsRight() {
        let result = MotionThreshold.direction(for: sample(ax: 0.8))
        XCTAssertEqual(result, .right)
    }
    
    func testStrongNegativeXAcceleration_returnsLeft() {
        let result = MotionThreshold.direction(for: sample(ax: -0.8))
        XCTAssertEqual(result, .left)
    }
    
    func testRotationAboveThreshold_whenAccelerationBelowThreshold_returnsDirection() {
        let result = MotionThreshold.direction(for: sample(ax: 0.1, ay: 0.1, ry: -1.5))
        XCTAssertEqual(result, .up)
    }
}
