//
//  GameEngine.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

protocol GameEngineProtocol {
    var movesDirections: [Direction] { get }
    
    func generateNewMove()
    func compareMove(_ input: Direction, at index: Int) -> Bool
    func start()

}

final class GameEngineMock: GameEngineProtocol {
    var movesDirections: [Direction] = []
    
    func generateNewMove() {
        movesDirections.append(Direction.allCases.randomElement()!)
    }
    
    func compareMove(_ input: Direction, at index: Int) -> Bool {
        return movesDirections[index] == input
    }
    
    func start() {
        movesDirections = []
        generateNewMove()
    }
}
