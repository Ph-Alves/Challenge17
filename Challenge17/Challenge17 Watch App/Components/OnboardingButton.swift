//
//  OnboardingButton.swift
//  Challenge17 Watch App
//
//  Created by Paulo Henrique Costa Alves on 19/08/26.
//

import SwiftUI

struct OnboardingButton: View {
    
    var buttonImage: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: buttonImage)
        }
        .buttonStyle(.plain)
        .padding()
        .background(.purple)
        .clipShape(Circle())
    }
}

#Preview {
    OnboardingButton(buttonImage: "chevron.right", action: {})
}
