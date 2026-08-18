//
//  HomeView.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import SwiftUI

struct HomeView: View {
    @State var vm = GameViewModel(gameEngine: GameEngineMock(), coreMotionManager: CoreMotionManager())
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: GameView(vm: vm)) {
                    Text("Play")
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(vm: GameViewModel(gameEngine: GameEngineMock(), coreMotionManager: CoreMotionManagerMock()))
}
