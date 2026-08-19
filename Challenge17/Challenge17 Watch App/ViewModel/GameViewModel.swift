//
//  GameViewModel.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import Observation

@Observable
final class GameViewModel {
    
    private(set) var highlightedDirection: GameDirection?
    private(set) var state: GameState = .idle
    private(set) var round: Int = 0
    
    var lastMotionSample: MotionSample?
    var workoutResult: WorkoutResult?
    
    
    @ObservationIgnored private let coreMotionManager: CoreMotionManagerProtocol
    @ObservationIgnored private let gameSession: GameSessionProtocol
    
    @ObservationIgnored private let workoutManager: WorkoutManagerProtocol

    enum GameState {
        case idle
        case running
        case waiting
        case finished
    }

    init(gameSession: GameSessionProtocol, coreMotionManager: CoreMotionManagerProtocol, workoutManager: WorkoutManagerProtocol) {
        self.gameSession = gameSession
        self.coreMotionManager = coreMotionManager
        self.workoutManager = workoutManager
        
        self.coreMotionManager.onMotionSample = { [weak self] sample in
            self?.lastMotionSample = sample
        }
        self.coreMotionManager.onDirectionDetected = { [weak self] direction in
            guard let self else { return }
            guard state == .waiting else { return }
            
            self.gameSession.receive(direction)
            self.coreMotionManager.stopCapturing()
        }
        
        self.gameSession.delegate = self
        
        
    }

    func start() {
        resetGameData()
        gameSession.start()
        
        workoutResult = nil
        workoutManager.startWorkout()
        state = .running
    }
    
    func stop() {
        gameSession.stop()
        coreMotionManager.stopCapturing()
        workoutManager.stopWorkout()
        
        workoutResult = workoutManager.workoutResult
    }

    func showHome() {
        stop()
        resetGameData()
        state = .idle
    }

    func showGameOver() {
        stop()
        state = .finished
    }
    
}

// MARK: - Internal
extension GameViewModel: GameSessionDelegate {
    
    func onEvent(_ event: GameEvent) {
        Task {
            await MainActor.run {
                self.updateState(for: event)
            }
        }
    }
    
    private func updateState(for event: GameEvent) {
        switch event {
        case .roundStarted(let currentRound):
            round = currentRound
            coreMotionManager.stopCapturing()
            state = .running
            
        case .show(let direction):
            highlightedDirection = direction
            
        case .hideDirection:
            highlightedDirection = nil
            
        case .waitingForInput:
            self.state = .waiting
            coreMotionManager.captureMoves()
            
        case .correctInput:
            coreMotionManager.captureMoves()
            
        case .gameOver:
            highlightedDirection = nil
            state = .finished
            coreMotionManager.stopCapturing()
        }
    }
    
    private func resetGameData() {
        highlightedDirection = nil
        round = 0
        lastMotionSample = nil
    }
}
