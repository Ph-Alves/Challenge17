//
//  GameSession.swift
//  Test-Watch
//
//  Created by Caio Mandarino on 17/08/26.
//


import Foundation

enum GameEvent: Equatable {
    case roundStarted(Int)
    case show(GameDirection)
    case hideDirection
    case waitingForInput
    case correctInput
    case gameOver
}

protocol GameSessionDelegate: AnyObject {
    func onEvent(_ event: GameEvent)
}

nonisolated protocol GameSessionProtocol: AnyObject {
    var delegate: GameSessionDelegate? { get set }
    
    func start()
    func receive(_ direction: GameDirection)
    func stop()
}

final class GameSession: GameSessionProtocol {

    private let engine: GameEngine
    weak var delegate: GameSessionDelegate?

    private let highlightDuration: Duration
    private let gapDuration: Duration

    private var playbackTask: Task<Void, Never>?
    private var round = 0


    init(
        engine: GameEngine = GameEngine(),
        highlightDuration: Duration = .milliseconds(500),
        gapDuration: Duration = .milliseconds(500)
    ) {
        self.engine = engine
        self.highlightDuration = highlightDuration
        self.gapDuration = gapDuration
    }

    deinit {
        playbackTask?.cancel()
    }

    func start() {
        playbackTask?.cancel()

        engine.start()
        round = 1

        playCurrentSequence()
    }

    func receive(_ direction: GameDirection) {
        let result = engine.verify(direction)

        switch result {
        case .correct:
            delegate?.onEvent(.correctInput)

        case .completed:
            startNextRound()

        case .incorrect:
            playbackTask?.cancel()
            delegate?.onEvent(.gameOver)
        }
    }

    func stop() {
        playbackTask?.cancel()
        engine.reset()
        round = 0
    }

    private func startNextRound() {
        engine.nextRound()
        round += 1

        playCurrentSequence()
    }

    private func playCurrentSequence() {
        playbackTask?.cancel()

        let sequence = engine.sequence

        playbackTask = Task { [weak self] in
            guard let self else { return }

            delegate?.onEvent(.roundStarted(round))

            engine.beginInput()

            for direction in sequence {
                guard !Task.isCancelled else {
                    return
                }

                delegate?.onEvent(.show(direction))

                do {
                    try await Task.sleep(for: highlightDuration)
                } catch {
                    return
                }

                guard !Task.isCancelled else {
                    return
                }

                delegate?.onEvent(.hideDirection)

                do {
                    try await Task.sleep(for: gapDuration)
                } catch {
                    return
                }
            }

            guard !Task.isCancelled else {
                return
            }

            delegate?.onEvent(.waitingForInput)
        }
    }
}
