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
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("BPM")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("\(vm.workoutResult?.duration.formatted(.number.precision(.fractionLength(0))) ?? "0")")
                        .bold()
                        .foregroundStyle(Color.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(alignment: .center) {
                    Text("Time")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text(Duration.seconds(vm.workoutResult?.duration ?? 0),format: .time(pattern: .minuteSecond))
                        .bold()
                        .foregroundStyle(.blue)
                }
                .frame(maxWidth: .infinity)
                
                
                VStack(alignment: .trailing) {
                    Text("CAL")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("\(vm.workoutResult?.calories.formatted(.number.precision(.fractionLength(0))) ?? "0")")
                        .bold()
                        .foregroundStyle(Color.orange)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                
            }
            
            Spacer()
            
            VStack(alignment: .center) {
                Text("Round")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("\(vm.round)")
                    .font(.title2)
                    .bold()
            }
            
            Spacer()
            
            HStack {
                Button {
                    vm.showHome()
                } label: {
                    Text("Home")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity, minHeight: 28)
                .background(Color.purple)
                .clipShape(Capsule())
                .shadow(color: .purple, radius: 2)
            }
            .frame(maxHeight: 28, alignment: .bottom)
            
            
        }
        .frame(width: .infinity, height: .infinity)
    }
}

#Preview {
    GameOverView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManagerMock(),
            workoutManager: WorkoutManager(),
            scoreRepository: ScoreRepository(),
            hapticService: HapticService()
        )
    )
}
