//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct Object: Hashable, CustomDebugStringConvertible, Codable {
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
    
    var isVisitable: Bool {
        attributes.isVisitable
    }
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
    
    enum Kind: Hashable, Codable {
        case generic
        case passableTerrain(Map.Object.Kind.PassableTerrain)
        
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

public extension Map.Object.Kind {
    enum PassableTerrain: Hashable, Codable {
        
        case hole, cursedGround, magicPlains, kelp, kelp2, hole2

        // SOD
        case cloverField, evilFog, favorableWinds, fieryFields, holyGround, lucidPools, magicClouds, rocklands, cursedGround2, magicPlains2
        
        /// Sub ID can have values: 139, 141, 142, 144, 145, 146
        case generic(subID: Int)
    }
}
//
//public extension Map.Object.Kind {
//    var entity: Any? {
//        switch self {
//        case .generic: return nil
//        case .garrison(let entity): return entity
//        case .artifact(let entity): return entity
//        case .resource(let entity): return entity
//        case .geoEvent(let entity): return entity
//        case .dwelling(let entity): return entity
//        case .hero(let entity): return entity
//        case .placeholderHero(let entity): return entity
//        case .resourceGenerator(let entity): return entity
//        case .abandonedMine(let entity): return entity
//        case .town(let entity): return entity
//        case .shipyard(let entity): return entity
//        case .shrine(let entity): return entity
//        case .sign(let entity): return entity
//        case .oceanBottle(let entity): return entity
//        case .scholar(let entity): return entity
//        case .seershut(let entity): return entity
//        case .monster(let entity): return entity
//        case .pandorasBox(let entity): return entity
//        case .questGuard(let entity): return entity
//        case .witchHut(let entity): return entity
//        case .lighthouse(let entity): return entity
//        case .grail(let entity): return entity
//        case .spellScroll(let entity): return entity
//        }
//    }
//}
