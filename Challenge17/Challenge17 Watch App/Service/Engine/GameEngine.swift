//
//  GameEngine.swift
//  Test-Watch
//
//  Created by Caio Mandarino on 17/08/26.
//

import Foundation

enum VerificationResult: Equatable {
    case correct
    case completed
    case incorrect
}

nonisolated final class GameEngine {

    private(set) var sequence: [GameDirection] = []
    private var currentInputIndex = 0

    private let randomDirection: () -> GameDirection

    init(
        randomDirection: @escaping () -> GameDirection = {
            GameDirection.allCases.randomElement() ?? .up
        }
    ) {
        self.randomDirection = randomDirection
    }

    /// Reinicia o jogo e cria a primeira direção da sequência.
    func start() {
        reset()
        nextRound()
    }

    /// Mantém toda a sequência anterior e adiciona uma nova direção.
    func nextRound() {
        sequence.append(randomDirection())
        currentInputIndex = 0
    }

    /// Reposiciona a validação no primeiro elemento da sequência.
    func beginInput() {
        currentInputIndex = 0
    }

    /// Verifica se o movimento recebido corresponde à posição atual da sequência.
    func verify(_ direction: GameDirection) -> VerificationResult {
        guard
            !sequence.isEmpty,
            currentInputIndex < sequence.count
        else {
            return .incorrect
        }

        guard sequence[currentInputIndex] == direction else {
            return .incorrect
        }

        currentInputIndex += 1

        if currentInputIndex == sequence.count {
            return .completed
        }

        return .correct
    }

    func reset() {
        sequence.removeAll()
        currentInputIndex = 0
    }
}
