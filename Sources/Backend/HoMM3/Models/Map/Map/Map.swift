//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.Loader.Parser {
    final class Inspector {
        
        public typealias OnParseBasicInfo = (Map.BasicInformation) -> Void
        
        public typealias OnParseCustomHeroes = (_ customHeroes: Map.AdditionalInformation.CustomHeroes) -> Void
        public typealias OnParseAvailableArtifacts = (_ availableArtifacts: Map.AdditionalInformation.AvailableArtifacts) -> Void
        public typealias OnParseAvailableSpells = (_ availableSpells:  Map.AdditionalInformation.AvailableSpells) -> Void
        public typealias OnParseAvailableSecondarySkills = (_ availableSecondarySkills:  Map.AdditionalInformation.AvailableSecondarySkills) -> Void
        public typealias OnParseRumors = (Map.AdditionalInformation.Rumors) -> Void
        public typealias OnParseHeroSettings = (Map.AdditionalInformation.HeroSettings) -> Void
        
        public typealias OnParseWorld = (Map.World) -> Void
        public typealias OnParseAttributesOfObjects = (Map.AttributesOfObjects) -> Void
        public typealias OnParseObject = (Map.Object) -> Void
        public typealias OnParseAllObjects = (Map.DetailsAboutObjects) -> Void
        public typealias OnParseEvents = (Map.GlobalEvents) -> Void

        private let onParseBasicInfo: OnParseBasicInfo?
        private let onParseCustomHeroes: OnParseCustomHeroes?
        private let onParseAvailableArtifacts: OnParseAvailableArtifacts?
        private let onParseAvailableSpells: OnParseAvailableSpells?
        private let onParseAvailableSecondarySkills: OnParseAvailableSecondarySkills?
        private let onParseRumors: OnParseRumors?
        private let onParseHeroSettings: OnParseHeroSettings?
        
        private let onParseWorld: OnParseWorld?
        private let onParseAttributesOfObjects: OnParseAttributesOfObjects?
        private let onParseObject: OnParseObject?
        private let onParseAllObjects: OnParseAllObjects?
        private let onParseEvents: OnParseEvents?
        
        public struct Settings {
            public let maxObjectsToParse: Int?
            public init(maxObjectsToParse: Int? = nil) {
                self.maxObjectsToParse = maxObjectsToParse
            }
        }
        
        public let settings: Settings
        
        init(
            settings: Settings = .init(),
            onParseBasicInfo: OnParseBasicInfo? = nil,
            onParseCustomHeroes: OnParseCustomHeroes? = nil,
            onParseAvailableArtifacts: OnParseAvailableArtifacts? = nil,
            onParseAvailableSpells: OnParseAvailableSpells? = nil,
            onParseAvailableSecondarySkills: OnParseAvailableSecondarySkills? = nil,
            
            onParseRumors: OnParseRumors? = nil,
            onParseHeroSettings: OnParseHeroSettings? = nil,
            onParseWorld: OnParseWorld? = nil,
            onParseAttributesOfObjects: OnParseAttributesOfObjects? = nil,
            onParseObject: OnParseObject? = nil,
            onParseAllObjects: OnParseAllObjects? = nil,
            onParseEvents: OnParseEvents? = nil
        ) {
            self.settings = settings
            self.onParseBasicInfo = onParseBasicInfo
            self.onParseCustomHeroes = onParseCustomHeroes
            self.onParseAvailableArtifacts = onParseAvailableArtifacts
            self.onParseAvailableSpells = onParseAvailableSpells
            self.onParseAvailableSecondarySkills = onParseAvailableSecondarySkills
            self.onParseRumors = onParseRumors
            self.onParseHeroSettings = onParseHeroSettings
            self.onParseWorld = onParseWorld
            self.onParseAttributesOfObjects = onParseAttributesOfObjects
            self.onParseObject = onParseObject
            self.onParseAllObjects = onParseAllObjects
            self.onParseEvents = onParseEvents
        }
    }
}
public extension Map.Loader.Parser.Inspector {
    
    func didParseBasicInfo(_ about: Map.BasicInformation) {
        onParseBasicInfo?(about)
    }
    
    func didParseCustomHeroes(_ customHeroes: Map.AdditionalInformation.CustomHeroes) {
        onParseCustomHeroes?(customHeroes)
    }
    
    func didParseAvailableArtifacts(_ availableArtifacts: Map.AdditionalInformation.AvailableArtifacts) {
        onParseAvailableArtifacts?(availableArtifacts)
    }
    
    func didParseAvailableSpells(_ availableSpells: Map.AdditionalInformation.AvailableSpells) {
        onParseAvailableSpells?(availableSpells)
    }
    
    func didParseAvailableSecondarySkills(_ availableSecondarySkills: Map.AdditionalInformation.AvailableSecondarySkills) {
        onParseAvailableSecondarySkills?(availableSecondarySkills)
    }
    
    func didParseRumors(_ rumors: Map.AdditionalInformation.Rumors) {
        onParseRumors?(rumors)
    }
    
    func didParseHeroSettings(_ heroSettings: Map.AdditionalInformation.HeroSettings) {
        onParseHeroSettings?(heroSettings)
    }
    
    func didParseWorld(_ world: Map.World) {
        onParseWorld?(world)
    }
    
    func didParseAttributesOfObjects(_ attributesOfObjects: Map.AttributesOfObjects) {
        onParseAttributesOfObjects?(attributesOfObjects)
    }
    
    func didParseObject(_ object: Map.Object) {
        onParseObject?(object)
    }
    
    func didParseAllObjects(_ objects: Map.DetailsAboutObjects) {
        onParseAllObjects?(objects)
    }
    
    func didParseEvents(_ events: Map.GlobalEvents) {
        onParseEvents?(events)
    }
}

public struct Map: Equatable, Identifiable {
    public let checksum: UInt32
    
    /// Name, description, size, difficulty etc.
    public let basicInformation: BasicInformation
    
    
    public let playersInfo: InformationAboutPlayers
    
    /// Victory/Loss conditions, teams, rumors, hero settings, SOD: avaiable skills/artifacts/spells etc.
    public let additionalInformation: AdditionalInformation
    
    public let world: World
    
    public let attributesOfObjects: Map.AttributesOfObjects
    public let detailsAboutObjects: Map.DetailsAboutObjects
    public let globalEvents: Map.GlobalEvents
}


extension Map {
    
    /// Reader, parser and caching of maps from disc.
    ///
    /// `internal` access modifier so that it can be tested.
    internal static let loader = Loader.shared
}


// MARK: Identifiable
public extension Map {
    var id: ID { basicInformation.id }
}

// MARK: Load
public extension Map {
    
    static func load(
        _ mapID: Map.ID,
        inspector: Map.Loader.Parser.Inspector? = nil
    ) throws -> Map {
        try loader.load(id: mapID, inspector: inspector)
    }
}

