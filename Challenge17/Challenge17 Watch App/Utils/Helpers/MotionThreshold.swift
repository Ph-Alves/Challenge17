
//
//  MotionThreshold.swift
//  Challenge17
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import Foundation

struct MotionThreshold {
    static let upThreshold: Double = 0.5 // Radianos (~23 graus)
    static let downThreshold: Double = 0.5 // Radianos (~23 graus)
    static let leftThreshold: Double = 0.5 // Radianos (~23 graus)
    static let rightThreshold: Double = 0.5 // Radianos (~23 graus)

    static func direction(for sample: MotionSample) -> GameDirection? {
        let pitch = sample.acceleration.x
        let roll = sample.acceleration.z

        let absPitch = abs(pitch)
        let absRoll = abs(roll)

        // Margem de segurança: O eixo de inclinação secundário deve ser menor que 40% do principal
        // Isso exige movimentos mais 'limpos' e isolados
        let marginFactor = 0.4

        if absPitch > absRoll {
            // Eixo Vertical (Pitch)
            guard absRoll < absPitch * marginFactor else { return nil }

            if pitch < 0 {
                return absPitch >= upThreshold ? .right : nil
            } else {
                return absPitch >= downThreshold ? .left : nil
            }
        } else {
            // Eixo Horizontal (Roll)
            guard absPitch < absRoll * marginFactor else { return nil }

            if roll > 0 {
                return absRoll >= rightThreshold ? .down : nil
            } else {
                return absRoll >= leftThreshold ? .up : nil
            }
        }
    }
}
