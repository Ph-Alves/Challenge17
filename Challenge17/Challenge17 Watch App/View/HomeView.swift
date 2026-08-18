//
//  HomeView.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import SwiftUI

struct HomeView: View {
    @State var vm = GameViewModel(gameSession: GameSession(), coreMotionManager: CoreMotionManager())
    
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
    HomeView()
}
