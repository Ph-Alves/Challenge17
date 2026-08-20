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
        coreMotionManager: CoreMotionManager(),
        workoutManager: WorkoutManager(),
        scoreRepository: ScoreRepository(),
        hapticService: HapticService()
    )

    var body: some Scene {
        WindowGroup {
            switch vm.state {
            case .idle:
                if vm.hasFinishedOnboarding {
                    HomeView(gameViewModel: vm)
                        .background(Color.viewBckg)
                } else {
                    OnboardingView(gameViewModel: vm)
                        .background(Color.viewBckg)
                }
            case .running, .waiting:
                GameView(vm: vm)
                    .background(Color.viewBckg)

            case .finished:
                GameOverView(vm: vm)
                    .background(Color.viewBckg)
            }
        }
    }
}
