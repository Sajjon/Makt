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
        public typealias OnParseWorld = (Map.World) -> Void
        public typealias OnParseDefinitions = (Map.Definitions) -> Void
        public typealias OnParseObject = (Map.Object) -> Void
        
        private let onParseAbout: OnParseAbout?
        private let onParseWorld: OnParseWorld?
        private let onParseDefinitions: OnParseDefinitions?
        private let onParseObject: OnParseObject?
        
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
            onParseWorld: OnParseWorld? = nil,
            onParseDefinitions: OnParseDefinitions? = nil,
            onParseObject: OnParseObject? = nil
        ) {
            self.settings = settings
            self.onParseAbout = onParseAbout
            self.onParseWorld = onParseWorld
            self.onParseDefinitions = onParseDefinitions
            self.onParseObject = onParseObject
        }
    }
}
public extension Map.Loader.Parser.Inspector {
    
    func didParseAbout(_ about: Map.About) {
        onParseAbout?(about)
    }
    
    func didParseDisposedHeroes(_ disposedHeroes: [Hero.Disposed]) {
        
    }
    
    func didParseAllowedArtifacts(_ allowedArtifacts: [Artifact.ID]) {
        
    }
    
    func didParseAllowedSpells(_ allowedSpells: [Spell.ID]) {
        
    }
    
    func didParseAllowedHeroAbilities(_ allowedHeroAbilities: [Hero.SecondarySkill.Kind]) {
        
    }
    
    func didParseRumors(_ rumors: [Map.Rumor]) {
        
    }
    
    func didParsePredefinedHeroes(_ predefinedHeroes: [Hero.Predefined]) {
        
    }
    
    func didParseWorld(_ world: Map.World) {
        onParseWorld?(world)
    }
    
    func didParseDefinitions(_ definitions: Map.Definitions) {
        onParseDefinitions?(definitions)
    }
    
    func didParseObject(_ object: Map.Object) {
        onParseObject?(object)
    }
}

public struct Map: Equatable, Identifiable {
    public let checksum: UInt32
    public let about: About
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

