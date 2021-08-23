//
//  Artifact+Slot.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Artifact {
    enum Slot: Hashable {
        case body(Body)
        /// Fits 64 unused artifacts
        case backpack(BackpackSlot)
    }
}

public extension Artifact.Slot {
    var isBackpack: Bool {
        switch self {
        case .backpack:
            return true
        case .body: return false
        }
    }
}

public extension Artifact.Slot {
    typealias RawValue = UInt8
    init?(id rawValue: RawValue) {
        if let body = Body.init(rawValue: rawValue) {
            self = .body(body)
        } else if let backpack = BackpackSlot(rawValue - UInt8(Body.allCases.count)) {
            self = .backpack(backpack)
        } else {
            return nil
        }
    }
    
    struct BackpackSlot: Hashable {
        public let slot: UInt8
        public init?(_ slot: UInt8) {
            guard slot < 64 else { return nil }
            self.slot = slot
        }
    }
}

public extension Artifact.Slot {
    
    enum Body: RawValue, Hashable, Comparable, CaseIterable {
        /// Helmet
        case head
        
        /// Cape
        case shoulders

        /// Necklace
        case neck
             
        /// Offensive
        case rightHand
             
        /// Defensive
        case leftHand
        
        /// Armour
        case torso
        
        /// Varies
        case rightRing
        
        /// Varies
        case leftRing

        /// Boots, typically hero movement boost
        case feet
        
        /// Miscellaneous slot top
        case misc1
        
        /// Miscellaneous slot second from top
        case misc2
        
        /// Miscellaneous slot third from top
        case misc3
        
        /// Miscellaneous right most slot
        case misc4
        
        /// War machine, left most slot: Ballista (or Cannon in HotA)
        case warMachine1
        
        /// War machine, corner slot ammo cart
        case warMachine2
        
        /// War machine slot second from bottom, reserved for first aid tent
        case warMachine3
        
        /// War machine bottom slot, reserve for catapult.
        case warMachine4
        
        /// Spell book
        case spellbook
        
        /// Bottom leftmost miscellaneous slot
        case misc5
    }
}

public extension Artifact.Slot.Body {
    static let ballistaSlot: Self = .warMachine1
    static let ammoCartSlot: Self = .warMachine2
    static let firstAidTentSlot: Self = .warMachine3
    static let catapultSlot: Self = .warMachine4
}

public extension Artifact.Slot {
    static let ballistaSlot: Self = .body(.ballistaSlot)
    static let ammoCartSlot: Self = .body(.ammoCartSlot)
    static let firstAidTentSlot: Self = .body(.firstAidTentSlot)
    static let catapultSlot: Self = .body(.catapultSlot)
}
