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
    private(set) var lastMotionSample: MotionSample?
    private(set) var workoutResult: WorkoutResult?
    private(set) var highScoreRound: Int
    private(set) var totalCaloriesBurned: Int
    
    @ObservationIgnored private let coreMotionManager: CoreMotionManagerProtocol
    @ObservationIgnored private let gameSession: GameSessionProtocol
    @ObservationIgnored private let workoutManager: WorkoutManagerProtocol
    @ObservationIgnored private let scoreRepository: ScoreRepositoryProtocol
    @ObservationIgnored private let hapticService: HapticServiceProtocol

    enum GameState {
        case idle
        case running
        case waiting
        case finished
    }

    init(
        gameSession: GameSessionProtocol,
        coreMotionManager: CoreMotionManagerProtocol,
        workoutManager: WorkoutManagerProtocol,
        scoreRepository: ScoreRepositoryProtocol,
        hapticService: HapticServiceProtocol
    ) {
        self.gameSession = gameSession
        self.coreMotionManager = coreMotionManager
        self.workoutManager = workoutManager
        self.scoreRepository = scoreRepository
        self.hapticService = hapticService
        self.highScoreRound = scoreRepository.highScoreRound
        self.totalCaloriesBurned = scoreRepository.totalCaloriesBurned
        
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
        syncStoredProgress()
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
            scoreRepository.updateHighScoreRound(currentRound)
            highScoreRound = scoreRepository.highScoreRound
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
            hapticService.playSuccess()
            coreMotionManager.captureMoves()
            
        case .gameOver:
            highlightedDirection = nil
            state = .finished
            coreMotionManager.stopCapturing()
            hapticService.playFailure()
        }
    }
    
    private func resetGameData() {
        highlightedDirection = nil
        round = 0
        lastMotionSample = nil
    }

    private func syncStoredProgress() {
        if let calories = workoutResult?.calories, calories > 0 {
            scoreRepository.addCaloriesBurned(Int(calories))
        }

        highScoreRound = scoreRepository.highScoreRound
        totalCaloriesBurned = scoreRepository.totalCaloriesBurned
    }
}
