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
    var workoutManager: WorkoutManagerProtocol
    
    init(gameEngine: GameEngineProtocol, coreMotionManager: CoreMotionManagerProtocol, workoutManager: WorkoutManagerProtocol) {
        self.gameEngine = gameEngine
        self.coreMotionManager = coreMotionManager
        self.workoutManager = workoutManager
    }
}
