//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map.Object {
    enum OneWayMonolith: UInt8, Hashable, CaseIterable, CustomDebugStringConvertible {
        
        /// Blue (Starfield)
        case blue,
             /// Red (white vortex)
             red,
             /// Yellow (gold/brown)
             yellow,
             yellowGlowing,
             purpleWithWhiteSwirl,
             yellowGlowingSpots,
             redSpiral,
             whiteGlowSphere
    }
}

public extension Map.Object.OneWayMonolith {
    var debugDescription: String {
        switch self {
            
            
            
        case .blue: return "blue"
        case .red: return "red"
        case .yellow: return "yellow"
        case .yellowGlowing: return "yellowGlowing"
        case .purpleWithWhiteSwirl: return "purpleWithWhiteSwirl"
        case .yellowGlowingSpots: return "yellowGlowingSpots"
        case .redSpiral: return "redSpiral"
        case .whiteGlowSphere: return "whiteGlowSphere"
            
            
        }
    }
}
