//
//  HapticService.swift
//  Challenge17
//
//  Created by Codex on 8/19/26.
//

import WatchKit

protocol HapticServiceProtocol {
    func playSuccess()
    func playFailure()
}

final class HapticService: HapticServiceProtocol {
    func playSuccess() {
        WKInterfaceDevice.current().play(.success)
    }

    func playFailure() {
        WKInterfaceDevice.current().play(.failure)
    }
}
