//
//  Challenge17App.swift
//  Challenge17 Watch App
//
//  Created by Paulo Henrique Costa Alves on 17/08/26.
//

import SwiftUI

@main
struct Challenge17_Watch_AppApp: App {
    @State private var vm = GameViewModel(
        gameSession: GameSession(),
        coreMotionManager: CoreMotionManager()
    )

    var body: some Scene {
        WindowGroup {
            switch vm.state {
            case .idle:
                HomeView(vm: vm)

            case .running, .waiting:
                GameView(vm: vm)

            case .finished:
                GameOverView(vm: vm)
            }
        }
    }
}
