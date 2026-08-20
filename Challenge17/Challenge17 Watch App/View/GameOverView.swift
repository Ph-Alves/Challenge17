//
//  GameOverView.swift
//  Challenge17
//
//  Created by Codex on 18/08/26.
//

import SwiftUI

struct GameOverView: View {
    let vm: GameViewModel
    

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Rounds: \(vm.round)")
                
                Text("Kcal: \(vm.workoutResult?.calories.formatted(.number.precision(.fractionLength(0))) ?? "0")")
            }
            
            HStack {
                Text("Time: \(Int(vm.workoutResult?.duration ?? 0)/60) : \(Int(vm.workoutResult?.duration ?? 0)%60)")
                
                Text("HR: \(vm.workoutResult?.duration.formatted(.number.precision(.fractionLength(0))) ?? "0") BPM")
                
            }
            
            Text("Game Over")

            Button("Home") {
                vm.showHome()
            }
        }
        .padding()
    }
}

#Preview {
    GameOverView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManagerMock(),
            workoutManager: WorkoutManager(),
            scoreRepository: ScoreRepository()
        )
    )
}
