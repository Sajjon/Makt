//
//  Map+Object.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-19.
//

import Foundation

public extension Map {
    struct DetailsAboutObjects: Hashable {
        public let objects: [Object]
    }
    
    /// Time based global events, trigger on certain days.
    struct TimedEvents: Hashable {
        public let events: [TimedEvent]
    }
  
    struct Object: Hashable, CustomDebugStringConvertible {
        public let position: Position
        public let attributes: Map.Object.Attributes
        public let kind: Kind
        
        /// used for testing
        internal let indexInObjectAttributesArray: UInt32
    }
    
    
    struct GuardedArtifact: Hashable {
        public let artifact: Artifact
        public let message: String?
        public let guards: CreatureStacks?
        public init(_ artifact: Artifact, message: String? = nil, guards: CreatureStacks? = nil) {
            self.artifact = artifact
            self.message = message
            self.guards = guards
        }
        
        static func specific(id artifactID: Artifact.ID, message: String? = nil, guards: CreatureStacks? = nil) -> Self {
            .init(.specific(id: artifactID), message: message, guards: guards)
        }
        static func random(`class`: Artifact.Class?, message: String? = nil, guards: CreatureStacks? = nil) -> Self {
            .init(.random(class: `class`), message: message, guards: guards)
        }
        static func scroll(spell spellID: Spell.ID, message: String? = nil, guards: CreatureStacks? = nil) -> Self {
            .init(.scroll(spell: spellID), message: message, guards: guards)
        }
    }
    
    struct Dwelling: Hashable {
        public let owner: PlayerColor?
        public let id: Object.ID
    }
    
    struct GuardedResource: Hashable, CustomDebugStringConvertible {
        public let message: String?
        public let guards: CreatureStacks?
        public let resourceKind: Resource.Kind
        public let resourceQuantity: Quantity
        
        public var debugDescription: String {
            let resourceString: String = {
                switch resourceQuantity {
                case .random: return "random amount of \(resourceKind)"
                case .specified(let quantity): return "\(quantity) \(resourceKind)"
                }
            }()
            let stringOptionals: [String?] = [
                resourceString,
                message.map { "message: \($0)" },
                guards.map { "guards: \($0)" }
            ]
            return stringOptionals.filterNils().joined(separator: "\n")
        }
    }
    
    struct Garrison: Hashable {
        let owner: PlayerColor?
        let creatures: CreatureStacks?
        let areCreaturesRemovable: Bool
    }
    
    
    struct Grail: Hashable {
        /// Map Editor "select allowable placement radius"
        public let radius: UInt32
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}
extension Optional: OptionalType {
    public var wrapped: Wrapped? {
        switch self {
        case .none: return nil
        case .some(let wrapped): return wrapped
        }
        
    }
}
public extension Sequence where Element: OptionalType {
    func filterNils() -> [Element.Wrapped] {
        compactMap({ $0.wrapped })
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
        case mine(Map.Mine)
        case town(Map.Town)
        case shipyard(Map.Shipyard)
        case shrine(Map.Shrine)
        case sign(Map.Sign)
        case oceanBottle(Map.OceanBottle)
        case scholar(Map.Scholar)
        case seershut(Map.Seershut)
        case monster(Map.Monster)
        case pandorasBox(Map.PandorasBox)
        case questGuard(Quest)
        case witchHut(Map.WitchHut)
        case lighthouse(Map.Lighthouse)
        case grail(Map.Grail)
        case spellScroll(Map.SpellScroll)
        
    }
}

public extension Map {
    
    struct WitchHut: Hashable {
        public let learnableSkills: [Hero.SecondarySkill.Kind]
    }
    
    struct Lighthouse: Hashable {
        public let owner: PlayerColor?
    }
    
    struct SpellScroll: Hashable {
        public let spell: Spell.ID
        public let message: String?
        public let guardians: CreatureStacks?
        public init(id spellID: Spell.ID, message: String? = nil, guardians: CreatureStacks? = nil) {
            self.spell = spellID
            self.message = message
            self.guardians = guardians
        }
    }
    
    struct Monster: Hashable, CustomDebugStringConvertible {
        
        public enum Kind: Hashable {
            case specific(creatureID: Creature.ID)
            case random(level: Creature.Level? = .any)
        }
        
        public let kind: Kind
        
        public let quantity: Quantity
        
        /// unique code for this monster (used in missions)
        public let missionIdentifier: UInt32?
        
        public let message: String?
        public let bounty: Bounty?
        
        public let disposition: Disposition
        
        public let mightFlee: Bool
        public let growsInNumbers: Bool
        
        public init(
            _ kind: Kind,
            quantity: Quantity = .random,
            missionIdentifier: UInt32? = nil,
            message: String? = nil,
            bounty: Bounty? = nil,
            disposition: Disposition = .aggressive,
            
            // Map Editor default is `true`
            mightFlee: Bool = true,
            
            // Map Editor default is `true`
            growsInNumbers: Bool = true
        ) {
            self.kind = kind
            self.quantity = quantity
            self.missionIdentifier = missionIdentifier
            self.message = message
            self.bounty = bounty
            self.disposition = disposition
            self.mightFlee = mightFlee
            self.growsInNumbers = growsInNumbers
        }
        
        public var debugDescription: String {
            let optionalStrings: [String?] = [
                "kind: \(kind)",
                "quantity: \(quantity)",
                missionIdentifier.map { "missionIdentifier: \($0)" } ?? nil,
                message.map { "message: \($0)" } ?? nil,
                bounty.map { "bounty: \($0)" } ?? nil,
                "disposition: \(disposition)",
                "mightFlee: \(mightFlee)",
                "growsInNumbers: \(growsInNumbers)"
           ]
            
            return optionalStrings.compactMap({ $0 }).joined(separator: "\n")
        }
    }
}

/// Used by Map.Monster and GuardedResource (resources on Map)
public enum Quantity: Hashable, CustomDebugStringConvertible {
    case random, specified(Int32) // might be negative
    
    public var debugDescription: String {
        switch self {
        case .random: return "random"
        case .specified(let quantity): return "#\(quantity)"
        }
        
    }
}

public extension Map.Monster {
    struct Bounty: Hashable {
        public let artifactID: Artifact.ID?
        public let resources: Resources?
        
        public init?(artifactID: Artifact.ID?, resources: Resources?) {
            if artifactID == nil && resources == nil { return nil }
            self.artifactID = artifactID
            self.resources = resources
        }
    }

    enum Disposition: UInt8, Hashable, CaseIterable {
        
        /// Will **always** join hero
        case compliant
        
        /// *Likely* to join hero
        case friendly
        
        /// *May* join hero
        case aggressive
        
        /// *Unlikely* to join hero
        case hostile
        
        /// Will **never** join hero
        case savage
    }
}
