//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation


public extension Map.Object {
    
    enum TwoWayMonolith: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        /// Green (lightning)
        case greenLighting,
             
        /// Orange (bubbles)
        orange,
        
        /// Purple (ripples)
        purple,
        
        /// Brown(ish)
        brown,
        
        // Green (energry)
        greenEnergy,
        
        explodingLine,
        glowingSphere,
             
        // In case of wog "snow portal"?
        whirlingShape
    }
}

public extension Map.Object.TwoWayMonolith {
    var debugDescription: String {
        switch self {
        case .greenLighting: return "greenLighting"
        case .orange: return "orange"
        case .purple: return "purple"
        case .brown: return "brown"
        case .greenEnergy: return "greenEnergy"
        case .explodingLine: return "explodingLine"
        case .glowingSphere: return "glowingSphere"
        case .whirlingShape: return "whirlingShape"
        }
    }
}
