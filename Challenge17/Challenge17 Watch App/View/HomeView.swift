//
//  HomeView.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import SwiftUI

struct HomeView: View {
    @State var vm = GameViewModel(gameEngine: GameEngineMock(), coreMotionManager: CoreMotionManager(), workoutManager: WorkoutManager())
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Play") {
                    GameView(vm: vm)
                }
                
                Button("Ask Permission") {
                    vm.workoutManager.askHealthPermission()
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
