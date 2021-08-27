//
//  Map.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-18.
//

import Foundation

public extension Map.Loader.Parser {
    final class Inspector {
        
        public typealias OnParseAbout = (Map.About) -> Void
        
        public typealias OnParseDisposedHeroes = (_ disposedHeroes: [Hero.Disposed]) -> Void
        public typealias OnParseAllowedArtifacts = (_ allowedArtifacts: [Artifact.ID]) -> Void
        public typealias OnParseAllowedSpells = (_ allowedSpells: [Spell.ID]) -> Void
        public typealias OnParseAllowedHeroAbilities = (_ allowedHeroAbilites: [Hero.SecondarySkill.Kind]) -> Void
        public typealias OnParseRumors = ([Map.Rumor]) -> Void
        public typealias OnParsePredefinedHeroes = ([Hero.Predefined]) -> Void
        
        public typealias OnParseWorld = (Map.World) -> Void
        public typealias OnParseAttributesOfObjects = (Map.AttributesOfObjects) -> Void
        public typealias OnParseObject = (Map.Object) -> Void
        public typealias OnParseAllObjects = (Map.DetailsAboutObjects) -> Void
        public typealias OnParseEvents = (Map.GlobalEvents) -> Void

        private let onParseAbout: OnParseAbout?
        private let onParseDisposedHeroes: OnParseDisposedHeroes?
        private let onParseAllowedArtifacts: OnParseAllowedArtifacts?
        private let onParseAllowedSpells: OnParseAllowedSpells?
        private let onParseAllowedHeroAbilities: OnParseAllowedHeroAbilities?
        private let onParseRumors: OnParseRumors?
        private let onParsePredefinedHeroes: OnParsePredefinedHeroes?
        
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
            onParseAbout: OnParseAbout? = nil,
            onParseDisposedHeroes: OnParseDisposedHeroes? = nil,
            onParseAllowedArtifacts: OnParseAllowedArtifacts? = nil,
            onParseAllowedSpells: OnParseAllowedSpells? = nil,
            onParseAllowedHeroAbilities: OnParseAllowedHeroAbilities? = nil,
            
            onParseRumors: OnParseRumors? = nil,
            onParsePredefinedHeroes: OnParsePredefinedHeroes? = nil,
            onParseWorld: OnParseWorld? = nil,
            onParseAttributesOfObjects: OnParseAttributesOfObjects? = nil,
            onParseObject: OnParseObject? = nil,
            onParseAllObjects: OnParseAllObjects? = nil,
            onParseEvents: OnParseEvents? = nil
        ) {
            self.settings = settings
            self.onParseDisposedHeroes = onParseDisposedHeroes
            self.onParseAllowedArtifacts = onParseAllowedArtifacts
            self.onParseAllowedSpells = onParseAllowedSpells
            self.onParseAllowedHeroAbilities = onParseAllowedHeroAbilities
            self.onParseRumors = onParseRumors
            self.onParsePredefinedHeroes = onParsePredefinedHeroes
            self.onParseAbout = onParseAbout
            self.onParseWorld = onParseWorld
            self.onParseAttributesOfObjects = onParseAttributesOfObjects
            self.onParseObject = onParseObject
            self.onParseAllObjects = onParseAllObjects
            self.onParseEvents = onParseEvents
        }
    }
}
public extension Map.Loader.Parser.Inspector {
    
    func didParseAbout(_ about: Map.About) {
        onParseAbout?(about)
    }
    
    func didParseDisposedHeroes(_ disposedHeroes: [Hero.Disposed]) {
        onParseDisposedHeroes?(disposedHeroes)
    }
    
    func didParseAllowedArtifacts(_ allowedArtifacts: [Artifact.ID]) {
        onParseAllowedArtifacts?(allowedArtifacts)
        
    }
    
    func didParseAllowedSpells(_ allowedSpells: [Spell.ID]) {
        onParseAllowedSpells?(allowedSpells)
    }
    
    func didParseAllowedHeroAbilities(_ allowedHeroAbilities: [Hero.SecondarySkill.Kind]) {
        onParseAllowedHeroAbilities?(allowedHeroAbilities)
    }
    
    func didParseRumors(_ rumors: [Map.Rumor]) {
        onParseRumors?(rumors)
    }
    
    func didParsePredefinedHeroes(_ predefinedHeroes: [Hero.Predefined]) {
        onParsePredefinedHeroes?(predefinedHeroes)
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
    public let about: About
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
    var id: ID { about.id }
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

