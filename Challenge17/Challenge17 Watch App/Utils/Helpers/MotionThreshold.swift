//
//  MotionThreshold.swift
//  Challenge17
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import Foundation

struct MotionThreshold {
    static let accelerationThreshold: Double = 0.5 //g's
    static let rotationThreshold: Double = 1.0 //rad's
    
    static func direction(for sample: MotionSample) -> Direction? {
        if let direction = dominantDirection(x: sample.acceleration.x,
                                             y: sample.acceleration.y,
                                             threshold: accelerationThreshold) {
            return direction
        }
        return dominantDirection(x: sample.rotationRate.x,
                                 y: sample.rotationRate.y,
                                 threshold: rotationThreshold)
    }
    
    private static func dominantDirection(x: Double, y: Double, threshold: Double) -> Direction? {
        let absX = abs(x)
        let absY = abs(y)
        guard max(absX, absY) >= threshold else { return nil }
        if absY >= absX {
            return y < 0 ? .up : .down
        } else {
            return x > 0 ? .right : .left
        }
    }
}
