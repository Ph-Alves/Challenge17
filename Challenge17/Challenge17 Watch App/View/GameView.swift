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

            Text("Round: \(vm.round)")
            
            Button("End Game") {
                vm.showGameOver()
            }
        }
        .padding()
    }
}

#Preview {
    GameView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManagerMock()
        )
    )
}
