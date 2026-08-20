//
//  CoreMotionManager.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import CoreMotion

protocol CoreMotionManagerProtocol: AnyObject {
    var onMotionSample: ((MotionSample) -> Void)? { get set }
    var onDirectionDetected: ((GameDirection) -> Void)? { get set }
    
    func captureMoves()
    func stopCapturing()
    func defineMove(from sample: MotionSample) -> GameDirection?
}

final class CoreMotionManager: CoreMotionManagerProtocol {
    private let motionManager: CMMotionManager
    private var referenceAttitude: CMAttitude?
    private var lastEmittedAt: Date?
    private let minimumIntervalBetweenMoves: TimeInterval = 1.0
    private var isAwaitingReturnToOrigin = false
    private let originThreshold: Double = 0.15 // Radianos (~9 graus) para considerar o braço de volta a posicao de origem
    
    var onMotionSample: ((MotionSample) -> Void)?
    var onDirectionDetected: ((GameDirection) -> Void)?
    
    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
    }
    
    func captureMoves() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        
        self.referenceAttitude = nil
        self.isAwaitingReturnToOrigin = false

        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main) { [weak self] motion, error in
            guard let self, let motion else { return }
            
            if self.referenceAttitude == nil {
                self.referenceAttitude = motion.attitude.copy() as? CMAttitude
                return // Pula o primeiro frame para estabelecer a referência
            }
            
            guard let ref = self.referenceAttitude,
                  let currentAttitude = motion.attitude.copy() as? CMAttitude else { return }
            
            currentAttitude.multiply(byInverseOf: ref)
            
            let sample = MotionSample(
                acceleration: MotionAxisData(x: motion.userAcceleration.x,
                                             y: motion.userAcceleration.y,
                                             z: motion.userAcceleration.z),
                rotationRate: MotionAxisData(x: motion.rotationRate.x,
                                             y: motion.rotationRate.y,
                                             z: motion.rotationRate.z),
                attitude: MotionAxisData(x: currentAttitude.pitch,
                                         y: currentAttitude.roll,
                                         z: currentAttitude.yaw),
                timestamp: motion.timestamp
            )
            self.onMotionSample?(sample)

            if self.isAwaitingReturnToOrigin {
                if abs(sample.attitude.x) <= self.originThreshold && abs(sample.attitude.y) <= self.originThreshold {
                    self.isAwaitingReturnToOrigin = false
                }
                return
            }

            guard let direction = self.defineMove(from: sample) else { return }
            let now = Date()
            if let last = self.lastEmittedAt, now.timeIntervalSince(last) < self.minimumIntervalBetweenMoves {
                return
            }
            self.lastEmittedAt = now
            self.isAwaitingReturnToOrigin = true
            
            print("--- Motion Detected ---")
            print("Direction: \(direction)")
            print("Attitude - Pitch: \(String(format: "%.2f", sample.attitude.x)), Roll: \(String(format: "%.2f", sample.attitude.y)), Yaw: \(String(format: "%.2f", sample.attitude.z))")
            print("-----------------------")
            
            self.onDirectionDetected?(direction)
        }
    }
    func stopCapturing() {
        motionManager.stopDeviceMotionUpdates()
        lastEmittedAt = nil
        referenceAttitude = nil
        isAwaitingReturnToOrigin = false
    }
    
    func defineMove(from sample: MotionSample) -> GameDirection? {
        MotionThreshold.direction(for: sample)
    }
}
