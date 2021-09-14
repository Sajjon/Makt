//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Object: Hashable, CustomDebugStringConvertible {
        public let position: Position
        public let attributes: Map.Object.Attributes
        public let kind: Kind
        
        public init(
            position: Position,
            attributes: Map.Object.Attributes,
            kind: Kind
        ) {
            self.position = position
            self.attributes = attributes
            self.kind = kind
        }
    }
}



public extension Map.Object {
    var objectID: ID { attributes.objectID }
}

public extension Map.Object {

    var debugDescription: String {
        """
        \n\n
        =========================================
        \(objectID.name)@\(position)
        -----------------------------------------
        \(kind)
        =========================================
        """
    }
    
    enum Kind: Hashable {
        case generic
        case garrison(Map.Garrison)
        case artifact(Map.GuardedArtifact)
        case resource(Map.GuardedResource)
        case geoEvent(Map.GeoEvent)
        case dwelling(Map.Dwelling)
        case hero(Hero)
        case placeholderHero(Hero.Placeholder)
        
        /// Mine, sawmills, alchemy labs etc, but NOT AbandonedMine, that is handled seperatly.
        case resourceGenerator(Map.ResourceGenerator)
        
        case abandonedMine(Map.AbandonedMine)
        case town(Map.Town)
        case shipyard(Map.Shipyard)
        case shrine(Map.Shrine)
        case sign(Map.Sign)
        case oceanBottle(Map.OceanBottle)
        case scholar(Map.Scholar)
        case seershut(Map.Seershut)
        case monster(Map.Monster)
        case pandorasBox(Map.PandorasBox)
        case questGuard(Quest?)
        case witchHut(Map.WitchHut)
        case lighthouse(Map.Lighthouse)
        case grail(Map.Grail)
        case spellScroll(Map.SpellScroll)
        
    }
}
