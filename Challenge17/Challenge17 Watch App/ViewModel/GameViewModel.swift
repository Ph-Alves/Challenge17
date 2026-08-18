//
//  GameViewModel.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import Observation

@Observable
final class GameViewModel {
    var gameEngine: GameEngineProtocol
    var coreMotionManager: CoreMotionManagerProtocol
    var currentIndex: Int = 0
    var lastMotionSample: MotionSample?
    var isGameOver: Bool = false

    init(gameEngine: GameEngineProtocol, coreMotionManager: CoreMotionManagerProtocol) {
        self.gameEngine = gameEngine
        self.coreMotionManager = coreMotionManager
        self.coreMotionManager.onMotionSample = { [weak self] sample in
            self?.lastMotionSample = sample
        }
        self.coreMotionManager.onDirectionDetected = { [weak self] direction in
            guard let self else { return }
            let isCorrect = self.gameEngine.compareMove(direction, at: self.currentIndex)
            guard isCorrect else {
                self.isGameOver = true
                self.coreMotionManager.stopCapturing()
                return
            }
            self.currentIndex += 1
            if self.currentIndex == self.gameEngine.movesDirections.count {
                self.gameEngine.generateNewMove()
            }
        }
    }

    func start() {
        currentIndex = 0
        isGameOver = false
        gameEngine.start()
        coreMotionManager.captureMoves()
    }
    
    func stop() {
        coreMotionManager.stopCapturing()
    }
}
