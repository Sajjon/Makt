//
//  Hero+Placeholder.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-24.
//

import Foundation

public extension Hero {
    ///  "Hero Placeholders are essential when creating campaign scenarios, but completely useless in normal scenarios (maps)."
    ///  source: http://www.heroesofmightandmagic.com/heroes3ab/mapeditors.shtml
    struct Placeholder: Hashable {
        public let owner: Player
        public let identity: Identity
        
        public init(owner: Player, identity: Identity) {
            self.owner = owner
            self.identity = identity
        }
        
        public enum Identity: Hashable {
            case anyHero(powerRating: PowerRating)
            case specificHero(Hero.ID)
        }
    }
}

public extension Hero.Placeholder.Identity {
    /// "You can customize power rating of Hero Placeholder, this way you may have the most powerful (or second/third...eigth most powerful)"
    /// source: http://www.heroesofmightandmagic.com/heroes3ab/mapeditors.shtml
    enum PowerRating: UInt8, Hashable, CaseIterable {
        case strongest
        case secondStrongest
        case thirdStrongest
        case fourthStrongest
        case fifthStrongest
        case sixStrongest
        case seventhStrongest
        case weakestOfEight
    }
}
