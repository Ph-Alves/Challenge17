//
//  CoreMotionManagerMock.swift
//  Challenge17 Watch App
//

import Foundation

final class CoreMotionManagerMock: CoreMotionManagerProtocol {
    var onMotionSample: ((MotionSample) -> Void)?
    var onDirectionDetected: ((Direction) -> Void)?
    
    func captureMoves() {
        // Mock implementation
    }
    
    func stopCapturing() {
        // Mock implementation
    }
    
    func defineMove(from sample: MotionSample) -> Direction? {
        return nil
    }
}
