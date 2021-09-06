//
//  Map+AdditionalInformation.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-28.
//

import Foundation

public extension Map {
    struct AdditionalInformation: Hashable {
        
        public let victoryLossConditions: VictoryLossConditions
        public let teamInfo: TeamInfo
        public let availableHeroes: AvailableHeroes
        
        /// SOD feature only
        public let customHeroes: CustomHeroes?
        
        /// AB/SOD feature only
        public let availableArtifacts: AvailableArtifacts?
        
        /// SOD feature only
        public let availableSpells: AvailableSpells?
        
        /// SOD feature only
        public let availableSecondarySkills: AvailableSecondarySkills?
        
        public let rumors: Rumors
        
        /// SOD feature onlu
        public let heroSettings: HeroSettings?
    }
}

public extension Map.AdditionalInformation {
    struct AvailableSpells: Hashable {
        public let spells: [Spell.ID]
    }
    
    struct AvailableSecondarySkills: Hashable {
        public let secondarySkills: [Hero.SecondarySkill.Kind]
    }
    
    struct AvailableArtifacts: Hashable {
        public let artifactIDs: ArtifactIDs
    }
    
    struct Rumors: Hashable {
        public let rumors: [Map.Rumor]
    }
    
    struct HeroSettings: Hashable {
        public let settingsForHeroes: [SettingsForHero]
    }
}


public struct CollectionOf<Element, Tag>: Collection {
    public let values: [Element]
}
public extension CollectionOf {
    typealias Index = Array<Element>.Index
    var startIndex: Index { values.startIndex }
    var endIndex: Index { values.endIndex }
    func index(after index: Index) -> Index {
        values.index(after: index)
    }
    subscript(position: Index) -> Element { values[position] }
//    The startIndex and endIndex properties
//    A subscript that provides at least read-only access to your type’s elements
//    The index(after:) method for advancing an index into your collection
}
extension CollectionOf: Equatable where Element: Equatable {}
extension CollectionOf: Hashable where Element: Hashable {}
public enum ArtifactIDsTag: Hashable {}
public typealias ArtifactIDs = CollectionOf<Artifact.ID, ArtifactIDsTag>
public enum SpellIDsTag: Hashable {}
public typealias SpellIDs = CollectionOf<Spell.ID, SpellIDsTag>
//public struct Artifacts: Hashable {
//    public let artifacts: [Artifact.ID]
//}
public extension Hero {
    enum PrimarySkillsTag: Hashable {}
    typealias PrimarySkills = CollectionOf<PrimarySkill, PrimarySkillsTag>
    
    enum SecondarySkillsTag: Hashable {}
    typealias SecondarySkills = CollectionOf<SecondarySkill, SecondarySkillsTag>
}
