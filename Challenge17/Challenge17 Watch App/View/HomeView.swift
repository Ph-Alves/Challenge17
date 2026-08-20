//
//  HomeView.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/17/26.
//

import SwiftUI

struct HomeView: View {
    let gameViewModel: GameViewModel
    
    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading) {
                    Text("Recorde:")
                        .foregroundStyle(.gray)
                    Text("\(gameViewModel.highScoreRound)")
                        .fontWeight(.bold)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Calorias:")
                        .foregroundStyle(.gray)
                    Text("\(gameViewModel.totalCaloriesBurned)")
                        .foregroundStyle(.yellow.opacity(0.9))
                        .fontWeight(.bold)
                }
                    
            }
            
            Spacer()
            
            Button{
                gameViewModel.start()
            } label: {
                Image(systemName: "play.fill")
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
            .padding(20)
            .background(.purple)
            .clipShape(Circle())
            .shadow(color: .purple, radius: 10)
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "questionmark")
                }
                .buttonStyle(.plain)
                .padding()
                .overlay(Circle().stroke(.gray))
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView(
        gameViewModel: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManagerMock(),
            workoutManager: WorkoutManager(),
            scoreRepository: ScoreRepository()
        )
    )
}
