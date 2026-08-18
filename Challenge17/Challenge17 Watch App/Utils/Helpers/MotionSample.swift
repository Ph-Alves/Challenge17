//
//  MotionSample.swift
//  Challenge17
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import Foundation

struct MotionAxisData: Equatable {
    let x: Double
    let y: Double
    let z: Double
}

struct MotionSample: Equatable {
    let acceleration: MotionAxisData // userAcceleration (CMDeviceMotion)
    let rotationRate: MotionAxisData // rotationRate (giroscopio, CMDeviceMotion)
    let timestamp: TimeInterval
}
