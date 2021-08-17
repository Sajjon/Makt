//
//  Map+VictoryLossCondition.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation


public extension Map {
    
    struct VictoryCondition: Equatable {
        public let kind: Kind
        public let appliesToAI: Bool
    }
}

public extension Map.VictoryCondition {
    
    static let standard = Self.init(kind: .standard, appliesToAI: true)
    
    var victoryIconID: UInt8 {
        kind.victoryIconID
    }
    
    enum Kind: Equatable {
        /// You must find a specific artifact. Win by placing the artifact in one of your heroes’ backpacks.
        case acquireSpecificArtifact(Artifact.ID)
        
        /// Your kingdom must acquire X number of a specific type of creature.
        case accumulateCreatures(kind: Creature.ID, amount: Int)
        
        ///  Your kingdom must acquire X amount of a specific resource.
        case accumulateResources(kind: Resource.Kind, amount: Resource.Amount)
        
        /// The hall and castle of a given town must be upgraded to a specified level.
        case upgradeSpecificTown(
                townLocation: Position,
                upgradeHallToLevel: Int,
                upgradeFortToLevel: Int
             )
        
        /// Find the Grail and build a grail building in one of your towns.
        case buildGrailBuilding(inTownLocatedAt: Position)
        
        /// Defeat a specified hero.
        case defeatSpecificHero(locatedAt: Position)
        
        /// Occupy a specified town.
        case captureSpecificTown(locatedAt: Position)
        
        /// Defeat a specified wandering monster.
        case defeatSpecificCreature(locatedAt: Position)
        
        /// You must control all the creature dwellings/generators on the map.
        case flagAllCreatureDwellings
        
        ///  Control all the mines on the map.
        case flagAllMines
        
        /// Acquire a specific artifact and transport it to a specified town.
        case transportSpecificArtifact(id: Artifact.ID, toTownLocatedAt: Position)
        
        /// Conquer all enemy towns and defeat all enemy heroes.
        case defeatAllEnemies
    }
}

public extension Map.VictoryCondition.Kind {
    
    enum Error: Swift.Error {
        case position(of: String, isRequiredFor: Stripped)
        case missingParameter(contents: String, for: Stripped)
        case unrecognizedResourceKind(Resource.Kind.RawValue)
    }
    
    init(
        stripped: Stripped,
        parameter1: Int? = nil,
        parameter2: Int? = nil,
        position: Position? = nil
    ) throws {
        
        
        func ensurePosition(of objectOfInterestAtPosition: String) throws -> Position {
            guard let position = position else {
                throw Error.position(of: objectOfInterestAtPosition, isRequiredFor: stripped)
            }
            return position
        }
        
        func ensureTownPosition() throws -> Position {
            try ensurePosition(of: "Town")
        }
        func ensureHeroPosition() throws -> Position {
            try ensurePosition(of: "Hero")
        }
        
        func ensureParameter1(contents: String) throws -> Int {
            guard let parameter = parameter1 else {
                throw Error.missingParameter(contents: contents, for: stripped)
            }
            return parameter
        }
        func ensureArtifactID() throws -> Artifact.ID {
            Artifact.ID(id: try ensureParameter1(contents: "Artifact ID"))
        }
        func ensureHeroID() throws -> Hero.ID {
            Hero.ID(id: try ensureParameter1(contents: "Hero ID"))
        }
        func ensureParameter2(contents: String) throws -> Int {
            guard let parameter = parameter2 else {
                throw Error.missingParameter(contents: contents, for: stripped)
            }
            return parameter
        }
        
        switch stripped {
        case .acquireSpecificArtifact:
            assert(parameter2 == nil)
            assert(position == nil)
            self = .acquireSpecificArtifact(try ensureArtifactID())
        case .accumulateCreatures:
            let creatureKindRaw = try ensureParameter1(contents: "Creature kind")
            let creatureKind = Creature.ID(id: creatureKindRaw)
            let creatureAmount = try ensureParameter2(contents: "Creature amount")
            assert(position == nil)
            self = .accumulateCreatures(
                kind: creatureKind,
                amount: creatureAmount
            )
            
        case .accumulateResources:
            let resourceKindRaw = try ensureParameter1(contents: "Resource kind")
            guard let resourceKind = Resource.Kind(rawValue: resourceKindRaw) else {
                throw Error.unrecognizedResourceKind(resourceKindRaw)
            }
            let amount = try ensureParameter2(contents: "Resource amount")
            assert(position == nil)
            self = .accumulateResources(
                kind: resourceKind,
                amount: amount
            )
            
        case .upgradeSpecificTown:
             let townPosition = try ensureTownPosition()
            let hallLevel = try ensureParameter1(contents: "Hall level")
            let fortLevel = try ensureParameter2(contents: "Fort/Castle level")
            self = .upgradeSpecificTown(
                townLocation: townPosition,
                upgradeHallToLevel: hallLevel,
                upgradeFortToLevel: fortLevel
            )
            
        case .buildGrailBuilding:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            let townPosition = try ensureTownPosition()
            
            // https://github.com/vcmi/vcmi/blob/ecaa9f5d0bfa96a68d886e58e05a7cf8b64d1b4f/lib/mapping/MapFormatH3M.cpp#L407-#L408
            guard townPosition.z <= 2 else {
                fatalError("According to VCMI town should not have Z > 2")
            }
            
            self = .buildGrailBuilding(inTownLocatedAt: townPosition)
            
        case .defeatSpecificHero:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            self = .defeatSpecificHero(locatedAt: try ensureHeroPosition())
            
        case .captureSpecificTown:
            self = .captureSpecificTown(locatedAt: try ensureTownPosition())
            
        case .defeatSpecificCreature:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            self = .defeatSpecificCreature(locatedAt: try ensurePosition(of: "Creature"))
        case .flagAllCreatureDwellings:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            assert(position == nil)
            self = .flagAllCreatureDwellings
            
        case .flagAllMines:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            assert(position == nil)
            self = .flagAllMines
            
        case .transportSpecificArtifact:
            assert(parameter2 == nil)
            self = .transportSpecificArtifact(id: try ensureArtifactID(), toTownLocatedAt: try ensureTownPosition())
            
        case .defeatAllEnemies:
            assert(parameter1 == nil)
            assert(parameter2 == nil)
            assert(position == nil)
            self = .defeatAllEnemies
        }
    }
    
    
}

public extension Map.VictoryCondition.Kind {
    var victoryIconID: UInt8 {
        if self == .defeatAllEnemies {
            // https://github.com/vcmi/vcmi/blob/ecaa9f5d0bfa96a68d886e58e05a7cf8b64d1b4f/lib/mapping/MapFormatH3M.cpp#L322
            return 11
        } else {
            return stripped.rawValue
        }
    }
    
    var stripped: Stripped {
        switch self {
        case .acquireSpecificArtifact: return .acquireSpecificArtifact
        case .defeatAllEnemies: return .defeatAllEnemies
        case .accumulateCreatures: return .accumulateCreatures
        case .accumulateResources: return .accumulateResources
        case .captureSpecificTown: return .captureSpecificTown
        case .flagAllCreatureDwellings: return .flagAllCreatureDwellings
        case .flagAllMines: return .flagAllMines
        case .upgradeSpecificTown: return .upgradeSpecificTown
        case .buildGrailBuilding: return .buildGrailBuilding
        case .defeatSpecificHero: return .defeatSpecificHero
        case .defeatSpecificCreature: return .defeatSpecificCreature
        case .transportSpecificArtifact: return .transportSpecificArtifact
        }
    }
    
    static let standard: Self = .defeatAllEnemies
}

public extension Map.VictoryCondition.Kind {
    enum Stripped: UInt8, Equatable {
        
        /// You must find a specific artifact. Win by placing the artifact in one of your heroes’ backpacks.
        case acquireSpecificArtifact = 0
        
        /// Your kingdom must acquire X number of a specific type of creature.
        case accumulateCreatures = 1
        
        ///  Your kingdom must acquire X amount of a specific resource.
        case accumulateResources = 2
        
        /// The hall and castle of a given town must be upgraded to a specified level.
        case upgradeSpecificTown = 3
        
        /// Find the Grail and build a grail building in one of your towns.
        case buildGrailBuilding = 4
        
        /// Defeat a specified hero.
        case defeatSpecificHero = 5
   
        /// Occupy a specified town.
        case captureSpecificTown = 6
        
        /// Defeat a specified wandering monster.
        case defeatSpecificCreature = 7
        
        /// You must control all the creature dwellings/generators on the map.
        case flagAllCreatureDwellings = 8
        
        ///  Control all the mines on the map.
        case flagAllMines = 9
        
        /// Acquire a specific artifact and transport it to a specified town.
        case transportSpecificArtifact = 10
        
        /// Conquer all enemy towns and defeat all enemy heroes.
        ///
        /// Standard win condition.
        case defeatAllEnemies = 255
    }
}


public extension Map.VictoryCondition.Kind.Stripped {
    static let standard: Self = .defeatAllEnemies
}

