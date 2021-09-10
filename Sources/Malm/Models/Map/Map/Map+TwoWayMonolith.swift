//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation


public extension Map.Object {
    
    enum TwoWayMonolith: UInt8, Hashable, CaseIterable {
        /// Green (lightning)
        case greenLighting,
             
        /// Orange (bubbles)
        playerFive,
        
        /// Purple (ripples)
        playerSix,
        
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
