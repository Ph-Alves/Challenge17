//
//  ScoreRepository.swift
//  Challenge17
//
//  Created by Codex on 8/19/26.
//

import Foundation

protocol ScoreRepositoryProtocol {
    var hasFinishedOnboarding: Bool { get }
    var highScoreRound: Int { get }
    var totalCaloriesBurned: Int { get }

    func updateHighScoreRound(_ score: Int)
    func addCaloriesBurned(_ calories: Int)
    func finishOnboarding()
}

final class ScoreRepository: ScoreRepositoryProtocol {
    private enum Keys {
        static let hasFinishedOnboarding = "hasFinishedOnboarding"
        static let highScoreRound = "highScoreRound"
        static let totalCaloriesBurned = "totalCaloriesBurned"
    }

    private let userDefaults: UserDefaults

    
    var hasFinishedOnboarding: Bool {
        userDefaults.bool(forKey: Keys.hasFinishedOnboarding)
    }

    var highScoreRound: Int {
        userDefaults.integer(forKey: Keys.highScoreRound)
    }

    var totalCaloriesBurned: Int {
        userDefaults.integer(forKey: Keys.totalCaloriesBurned)
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func updateHighScoreRound(_ score: Int) {
        guard score > highScoreRound else { return }
        userDefaults.set(score, forKey: Keys.highScoreRound)
    }

    func addCaloriesBurned(_ calories: Int) {
        let updatedCalories = totalCaloriesBurned + calories
        userDefaults.set(updatedCalories, forKey: Keys.totalCaloriesBurned)
    }

    func finishOnboarding() {
        userDefaults.set(true, forKey: Keys.hasFinishedOnboarding)
    }
}
