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
            Color.viewBckg
                .ignoresSafeArea()

            if isCountingDown {
                CountdownRingView(countdown: countdown)
                    .onAppear {
                        startCountdown()
                    }
            } else {
                VStack {
                    HStack {
                        Button(action: {
                            isPaused = true
                            vm.pauseGame()
                        }) {
                            Image(systemName: "pause.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Text("Round: \(vm.round)")
                            .font(.headline)
                    }
                    Spacer()
                    
                    
                    if let direction = vm.highlightedDirection {
                        DirectionIcon(direction: direction)
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
                    Spacer()
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
                ResultOverlayView(color: .green, systemImage: "checkmark")
            }

            if vm.isRoundFailed {
                ResultOverlayView(color: .red, systemImage: "xmark")
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

struct CountdownRingView: View {
    let countdown: Int
    private let totalCount = 3

    @State private var progress: CGFloat = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.purple,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: .purple, radius: 6)

            Text("\(countdown)")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.purple)
                .shadow(color: .purple, radius: 8)
        }
        .frame(width: 130, height: 130)
        .onAppear {
            animateProgress()
        }
        .onChange(of: countdown) { _, _ in
            animateProgress()
        }
    }

    private func animateProgress() {
        progress = CGFloat(totalCount - countdown) / CGFloat(totalCount)
        withAnimation(.linear(duration: 1)) {
            progress = CGFloat(totalCount - countdown + 1) / CGFloat(totalCount)
        }
    }
}

struct ResultOverlayView: View {
    let color: Color
    let systemImage: String

    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()

            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 70, height: 70)
        }
        .transition(.opacity)
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
