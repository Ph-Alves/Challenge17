//
//  MotionThreshold.swift
//  Challenge17
//
//  Created by Joao pedro Leonel on 18/08/26.
//

import Foundation

struct MotionThreshold {
    static let attitudeThreshold: Double = 0.4 // Radianos (~23 graus)
    
    static func direction(for sample: MotionSample) -> GameDirection? {
        let pitch = sample.attitude.x
        let roll = sample.attitude.y
        
        let absPitch = abs(pitch)
        let absRoll = abs(roll)
        
        guard max(absPitch, absRoll) >= attitudeThreshold else { return nil }
        
        // Margem de segurança: O eixo de inclinação secundário deve ser menor que 40% do principal
        // Isso exige movimentos mais 'limpos' e isolados
        let marginFactor = 0.4
        
        if absPitch > absRoll {
            // Eixo Vertical (Pitch)
            if absRoll < absPitch * marginFactor {
                return pitch < 0 ? .up : .down
            }
        } else {
            // Eixo Horizontal (Roll)
            if absPitch < absRoll * marginFactor {
                return roll > 0 ? .right : .left
            }
        }
        
        return nil
    }
}
