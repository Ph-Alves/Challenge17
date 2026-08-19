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
            if vm.workoutManager.workoutResult != nil {
                Text("Time: \(vm.workoutManager.workoutResult?.duration ?? 0)")
                
                Text("Kcal: \(vm.workoutManager.workoutResult?.calories ?? 0)")
                
                Text("HR: \(vm.workoutManager.workoutResult?.heartRate ?? 0)")
            }
            
            Button("Finish Game") {
                vm.workoutManager.stopWorkout()
            }
        }
        .padding()
        .task{
            vm.workoutManager.startWorkout()
        }
    }
}

#Preview {
    GameView(vm: GameViewModel(gameEngine: GameEngineMock(), coreMotionManager: CoreMotionManager(), workoutManager: WorkoutManager()))
}
