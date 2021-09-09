//
//  Hero.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-16.
//

import Foundation

public struct Hero: Hashable, CustomDebugStringConvertible {
    public enum IdentifierKind: Hashable {
        case randomHero
        case specificHeroWithID(Hero.ID)
    }
    
    public enum Patrol: UInt8, CaseIterable, Hashable {
        case standstill = 0
        case oneSquare
        case twoSquares
        case threeSquares
        case fourSquares
        case fiveSquares
        case sixSquares
        case sevenSquares
        case eightSquares
        case nineSquares
        case tenSquares
    }
    
    public let identifierKind: IdentifierKind
    public let questIdentifier: UInt32?
    public let portraitID: ID?
    public let name: String?
    public let owner: Player?
    public let army: CreatureStacks?
    public let formation: CreatureStacks.Formation
    public let patrol: Patrol?
    
    public let startingExperiencePoints: UInt32
    public let startingSecondarySkills: SecondarySkills?
    public let artifactsInSlots: ArtifactsInSlots?
    public let biography: String?
    public let gender: Gender?
    public let spells: SpellIDs?
    public let primarySkills: PrimarySkills?
    
    public init(
        identifierKind: IdentifierKind,
        questIdentifier: UInt32? = nil,
        portraitID: ID? = nil,
        name: String? = nil,
        owner: Player? = nil,
        army: CreatureStacks? = nil,
        formation: CreatureStacks.Formation = .spread,
        patrol: Patrol? = nil,
        startingExperiencePoints: UInt32 = 0,
        startingSecondarySkills: SecondarySkills? = nil,
        artifactsInSlots: ArtifactsInSlots? = nil,
        biography: String? = nil,
        gender: Gender? = nil,
        spells: SpellIDs? = nil,
        primarySkills: PrimarySkills? = nil
    ) {
        self.identifierKind = identifierKind
        self.questIdentifier = questIdentifier
        self.portraitID = portraitID
        self.name = name
        self.owner = owner
        self.army = army
        self.formation = formation
        self.patrol = patrol
        self.startingExperiencePoints = startingExperiencePoints
        self.startingSecondarySkills = startingSecondarySkills
        self.artifactsInSlots = artifactsInSlots
        self.biography = biography
        self.gender = gender
        self.spells = spells
        self.primarySkills = primarySkills
    }
    

    
    public var debugDescription: String {
        let optionalStrings: [String?] = [
        "identifierKind: \(identifierKind)",
        questIdentifier.map { "questIdentifier: \($0)" } ?? nil,
        portraitID.map { "portraitID: \($0)" } ?? nil,
        name.map { "name: \($0)" } ?? nil,
        owner.map { "owner: \($0)" } ?? nil,
        army.map { "army: \($0)" } ?? nil,
        "formation: \(formation)",
        patrol.map { "patrol: \($0)" } ?? nil,
        "startingExperiencePoints: \(startingExperiencePoints)",
        startingSecondarySkills.map { "startingSecondarySkills: \($0)" } ?? nil,
        artifactsInSlots.map { "artifactsInSlots: \($0)" } ?? nil,
        biography.map { "biography: \($0)" } ?? nil,
        gender.map { "gender: \($0)" } ?? nil,
        spells.map { "spells: \($0)" } ?? nil,
        primarySkills.map { "primarySkills: \($0)" } ?? nil
       ]
        
        return optionalStrings.compactMap({ $0 }).joined(separator: "\n")
    }
}



public extension Hero {
    
    typealias ArtifactsInSlots = CollectionOf<ArtifactInSlot>
    
    struct ArtifactInSlot: Hashable, CustomDebugStringConvertible {
        public let slot: Artifact.Slot
        public let artifactID: Artifact.ID
        
        public var debugDescription: String {
            "\(artifactID)@\(slot)"
        }
    }
    
    var `class`: Hero.Class? {
        switch identifierKind {
        case .randomHero: return nil
        case .specificHeroWithID(let heroID): return heroID.class
        }
    }

}

public extension Hero {
    enum Class: UInt8, Hashable, CaseIterable {
        case
        knight,
        cleric,
        ranger,
        druid,
        alchemist,
        wizard,
        demoniac,
        heretic,
        deathKnight,
        necromancer,
        overlord,
        warlock,
        barbarian,
        battleMage,
        beastmaster,
        witch,
        planeswalker,
        elementalist
        #if HOTA
        case captain,
        navigator
        #endif // HOTA
        
       public init<I>(integer: I) throws where I: FixedWidthInteger {
           do {
               let rawValue = try UInt8(integer: integer)
               try self.init(id: rawValue)
           } catch {
               throw IDFromRawValueError<Self>.genericInteger(tooLarge: Int(integer))
           }
       }
        
    }
}
