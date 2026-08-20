//
//  ContentView.swift
//  Challenge17 Watch App
//
//  Created by Paulo Henrique Costa Alves on 17/08/26.
//

import SwiftUI

struct GameView: View {
    let vm: GameViewModel
    
    @State private var countdown = 3
    @State private var isCountingDown = true
    @State private var isPaused = false
    
    var body: some View {
        ZStack {
            if isCountingDown {
                Text("\(countdown)")
                    .font(.system(size: 80, weight: .bold))
                    .onAppear {
                        startCountdown()
                    }
            } else {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            isPaused = true
                            vm.pauseGame()
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Text("Round: \(vm.round)")
                        .font(.headline)
                    
                    if let direction = vm.highlightedDirection {
                        DirectionIcon(direction: direction)
                    } else if vm.state == .running {
                        Text("Atenção...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .frame(height: 60)
                    } else if vm.state == .waiting {
                        Text("Sua Vez!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                            .frame(height: 60)
                    } else {
                        // Empty space to prevent layout jump
                        Text(" ")
                            .font(.title2)
                            .frame(height: 60)
                    }
                }
                .padding()
            }
            
            if isPaused {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                VStack(spacing: 12) {
                    Text("Pausado")
                        .font(.headline)
                    
                    Button("Voltar") {
                        isPaused = false
                        vm.resumeGame()
                    }
                    
                    Button(role: .destructive, action: {
                        vm.showGameOver()
                    }) {
                        Text("Sair")
                    }
                }
                .padding()
            }
            
            if vm.isRoundCompleted {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.green)
                    Text("Passou!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    private func startCountdown() {
        Task {
            while countdown > 1 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled {
                    countdown -= 1
                }
            }
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            if !Task.isCancelled {
                isCountingDown = false
                vm.start()
            }
        }
    }
}

struct DirectionIcon: View {
    let direction: GameDirection
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .foregroundColor(iconColor)
    }
    
    private var iconName: String {
        switch direction {
        case .up: return "arrow.up.circle.fill"
        case .down: return "arrow.down.circle.fill"
        case .left: return "arrow.left.circle.fill"
        case .right: return "arrow.right.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch direction {
        case .up: return .green
        case .down: return .red
        case .left: return .yellow
        case .right: return .blue
        }
    }
}

#Preview {
    GameView(
        vm: GameViewModel(
            gameSession: GameSession(),
            coreMotionManager: CoreMotionManager(),
            workoutManager: WorkoutManager(),
            scoreRepository: ScoreRepository(),
            hapticService: HapticService()
        )
    )
}
