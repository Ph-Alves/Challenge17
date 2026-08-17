//
//  CoreMotionManager.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import CoreMotion

protocol CoreMotionManagerProtocol {
    func captureMoves() async
    
    func defineMove() -> Direction
}

final class CoreMotionManager: CoreMotionManagerProtocol {
    private let motionManager: CMMotionManager
    
    init() {
        self.motionManager = CMMotionManager()
    }
    
    func captureMoves() async {
        motionManager.startAccelerometerUpdates()
        
        /*
         lógica de captura de dados...
         */
    }
    
    func defineMove() -> Direction {
        let data = motionManager.accelerometerData
        
        /*
         lógica de definição de direção...
         */
        
        return .up // Modificar
    }
}
