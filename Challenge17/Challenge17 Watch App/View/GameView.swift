//
//  ContentView.swift
//  Challenge17 Watch App
//
//  Created by Paulo Henrique Costa Alves on 17/08/26.
//

import SwiftUI

struct GameView: View {
    let vm: GameViewModel
    
    var body: some View {
        VStack {
            Text("Our Game")
        }
        .padding()
    }
}

#Preview {
    GameView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManager(),
            workoutManager: WorkoutManager(),
            scoreRepository: ScoreRepository(),
            hapticService: HapticService()
        )
    )
}
