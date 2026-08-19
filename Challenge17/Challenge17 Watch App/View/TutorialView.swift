//
//  TutorialView.swift
//  Challenge17 Watch App
//
//  Created by Paulo Henrique Costa Alves on 19/08/26.
//

import SwiftUI
import Combine

struct TutorialView: View {
    
    let gameViewModel: GameViewModel
    
    @State private var step = 1
    @State private var currentFrame = 0
    @State private var currentDirection = 0
    
    private let arrows: [String] = [
        "arrow.up", "arrow.down", "arrow.left", "arrow.right"
    ]
    
    private let downFrameNames: [String] = [
        "baixo-01", "baixo-02", "baixo-03", "baixo-04", "baixo-05", "baixo-06",
        "baixo-07", "baixo-08", "baixo-09", "baixo-10", "baixo-11", "baixo-12",
    ]
    
    private let upFrameNames: [String] = [
        "cima-01", "cima-02", "cima-03", "cima-04", "cima-05", "cima-06",
        "cima-07", "cima-08", "cima-09", "cima-10", "cima-11", "cima-12",
    ]
    
    private let rightFrameNames: [String] = [
        "direita-01", "direita-02", "direita-03", "direita-04", "direita-05", "direita-06",
        "direita-07", "direita-08", "direita-09", "direita-10", "direita-11", "direita-12",
    ]
    
    private let leftFrameNames: [String] = [
        "esquerda-01", "esquerda-02", "esquerda-03", "esquerda-04", "esquerda-05", "esquerda-06",
        "esquerda-07", "esquerda-08", "esquerda-09", "esquerda-10", "esquerda-11", "esquerda-12",
    ]
    
    private var directions: [(arrow: String, frames: [String])] {
        [
            ("arrow.up", upFrameNames),
            ("arrow.down", downFrameNames),
            ("arrow.left", leftFrameNames),
            ("arrow.right", rightFrameNames)
        ]
    }
    
    private let frameTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        switch step {
        case 1:
            VStack {
                Text("Bem vindo(a) ao app!")
                Spacer()
                HStack {
                    Spacer()
                    OnboardingButton(buttonImage: "chevron.right", action: {
                        step += 1
                    })
                }
            }
        case 2:
            VStack(spacing: 10) {
                Text("Ao inciar, uma sequência de setas aparecerão!")
                
                Image(systemName: "arrow.left")
                    .font(.system(size: 40))
                
                Spacer()
                HStack {
                    OnboardingButton(buttonImage: "chevron.left", action: {
                        step -= 1
                    })
                    
                    Spacer()
                    
                    OnboardingButton(buttonImage: "chevron.right", action: {
                        step += 1
                    })
                }
            }
        case 3:
            VStack {
                Text("Movimente o braço na direção da seta!")
                    .multilineTextAlignment(.center)
                HStack {
                    Spacer()
                    
                    Image(systemName: directions[currentDirection].arrow)
                    
                    Spacer()
                    
                    Image(directions[currentDirection].frames[currentFrame])
                        .resizable()
                        .scaledToFit()
                        .onReceive(frameTimer) { _ in
                            if currentFrame == 11 {
                                currentFrame = 0
                                currentDirection = (currentDirection + 1) % directions.count
                            } else {
                                currentFrame += 1
                            }
                        }
                    
                    Spacer()
                }
                Spacer()
                HStack {
                    OnboardingButton(buttonImage: "chevron.left", action: {
                        step -= 1
                    })
                    
                    Spacer()
                    
                    OnboardingButton(buttonImage: "chevron.right", action: {
                        gameViewModel.completedOnboarding = true
                    })
                }
            }
        default:
            EmptyView()
        }
        
    }
}

#Preview {
    TutorialView(gameViewModel: GameViewModel(gameSession: GameSession(), coreMotionManager: CoreMotionManager()))
}
