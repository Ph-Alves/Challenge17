//
//  HomeView.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import SwiftUI

struct HomeView: View {
    let vm: GameViewModel
    
    var body: some View {
        VStack {
            Button("Play") {
                vm.start()
            }
        }
        .padding()
    }
}

#Preview {
    HomeView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManagerMock(), workoutManager: WorkoutManager()
        )
    )
}
