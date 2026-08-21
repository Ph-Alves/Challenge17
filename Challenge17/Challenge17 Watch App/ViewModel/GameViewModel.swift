//
//  GameViewModel.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import Observation
import Foundation

@Observable
final class GameViewModel {
    
    private(set) var highlightedDirection: GameDirection?
    private(set) var state: GameState = .idle
    private(set) var round: Int = 0
    private(set) var lastMotionSample: MotionSample?
    private(set) var workoutResult: WorkoutResult?
    private(set) var highScoreRound: Int
    private(set) var totalCaloriesBurned: Int
    private(set) var isRoundCompleted: Bool = false
    private(set) var isRoundFailed: Bool = false
    private(set) var hasFinishedOnboarding: Bool
    
    @ObservationIgnored private let coreMotionManager: CoreMotionManagerProtocol
    @ObservationIgnored private let gameSession: GameSessionProtocol
    @ObservationIgnored private let workoutManager: WorkoutManagerProtocol
    @ObservationIgnored private let scoreRepository: ScoreRepositoryProtocol
    @ObservationIgnored private let hapticService: HapticServiceProtocol

    enum GameState {
        case onBoarding
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
        self.hasFinishedOnboarding = scoreRepository.hasFinishedOnboarding
        
        if hasFinishedOnboarding {
            self.state = .idle
        } else {
            self.state = .onBoarding
        }
        
        self.coreMotionManager.onMotionSample = { [weak self] sample in
            self?.lastMotionSample = sample
        }
        self.coreMotionManager.onDirectionDetected = { [weak self] direction in
            guard let self else { return }
            guard state == .waiting else { return }
            
            self.gameSession.receive(direction)
        }
        
        self.gameSession.delegate = self
        
        
    }
    
    func startOnboarding() {
        state = .onBoarding
    }

    func start() {
        resetGameData()
        gameSession.start()
        
        workoutResult = nil
        workoutManager.startWorkout()
        state = .running
    }
    
    func prepareToPlay() {
        resetGameData()
        state = .running
    }
    
    func pauseGame() {
        if state == .waiting {
            coreMotionManager.stopCapturing()
        }
    }
    
    func resumeGame() {
        if state == .waiting {
            coreMotionManager.captureMoves()
        }
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
    
    func completedOnboarding(_ completed: Bool) {
        self.scoreRepository.finishOnboarding()
        self.hasFinishedOnboarding = completed
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
            isRoundCompleted = false
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
            
        case .roundCompleted:
            isRoundCompleted = true
            coreMotionManager.stopCapturing()
            
        case .gameOver:
            highlightedDirection = nil
            isRoundFailed = true
            coreMotionManager.stopCapturing()
            hapticService.playFailure()

            Task {
                try? await Task.sleep(for: .milliseconds(1200))
                await MainActor.run {
                    self.isRoundFailed = false
                    self.showGameOver()
                }
            }
        }
    }

    private func resetGameData() {
        highlightedDirection = nil
        isRoundCompleted = false
        isRoundFailed = false
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
