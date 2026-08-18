//
//  CoreMotionManager.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import CoreMotion

protocol CoreMotionManagerProtocol {
    var onMotionSample: ((MotionSample) -> Void)? { get set }
    var onDirectionDetected: ((GameDirection) -> Void)? { get set }
    
    func captureMoves()
    func stopCapturing()
    func defineMove(from sample: MotionSample) -> GameDirection?
}

final class CoreMotionManager: CoreMotionManagerProtocol {
    private let motionManager: CMMotionManager
    private var lastEmittedAt: Date?
    private let minimumIntervalBetweenMoves: TimeInterval = 0.4
    
    var onMotionSample: ((MotionSample) -> Void)?
    var onDirectionDetected: ((GameDirection) -> Void)?
    
    init(motionManager: CMMotionManager = CMMotionManager()) {
        self.motionManager = motionManager
    }
    
    func captureMoves() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self, let motion else { return }
            let sample = MotionSample(
                acceleration: MotionAxisData(x: motion.userAcceleration.x,
                                             y: motion.userAcceleration.y,
                                             z: motion.userAcceleration.z),
                rotationRate: MotionAxisData(x: motion.rotationRate.x,
                                             y: motion.rotationRate.y,
                                             z: motion.rotationRate.z),
                timestamp: motion.timestamp
            )
            self.onMotionSample?(sample)
            
            guard let direction = self.defineMove(from: sample) else { return }
            let now = Date()
            if let last = self.lastEmittedAt, now.timeIntervalSince(last) < self.minimumIntervalBetweenMoves {
                return
            }
            self.lastEmittedAt = now
            self.onDirectionDetected?(direction)
        }
    }
    func stopCapturing() {
        motionManager.stopDeviceMotionUpdates()
        lastEmittedAt = nil
    }
    
    func defineMove(from sample: MotionSample) -> GameDirection? {
        MotionThreshold.direction(for: sample)
    }
}
