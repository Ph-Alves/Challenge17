//
//  Direction.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

enum GameDirection: Equatable, CaseIterable {
    case up
    case down
    case right
    case left
}

extension GameDirection {
    func description() -> String {
        switch self {
        case .up:
            "up"
        case .down:
            "down"
        case .right:
            "right"
        case .left:
            "left"
        }
    }
}
