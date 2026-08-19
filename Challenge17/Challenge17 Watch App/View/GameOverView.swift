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
            coreMotionManager: CoreMotionManagerMock()
        )
    )
}
