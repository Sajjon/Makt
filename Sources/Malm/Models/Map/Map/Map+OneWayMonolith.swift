//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation

public extension Map.Object {
    enum OneWayMonolith: UInt8, Hashable, CaseIterable {
        
        /// Blue (Starfield)
        case playerTwo,
             
             /// Red (white vortex)
             playerOne,
             
             /// Yellow (gold/brown)
             yellow,
             
             yellowGlowing
        
        case purpleWithWhiteSwirl,
             yellowGlowingSpots,
             redSpiral,
             whiteGlowSphere
    }
}
