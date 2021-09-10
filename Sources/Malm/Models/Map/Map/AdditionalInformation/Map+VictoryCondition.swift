//
//  Map+VictoryLossCondition.swift
//  HoMM3SwiftUI
//
//  Created by Alexander Cyon on 2021-08-17.
//

import Foundation


public extension Map {
    
    struct VictoryCondition: Hashable {
        public let kind: Kind
        public let appliesToAI: Bool
        public init(kind: Kind, appliesToAI: Bool = false) {
            self.kind = kind
            self.appliesToAI = appliesToAI
        }
    }
}

public extension Map.VictoryCondition {
    
    static let standard = Self.init(kind: .standard, appliesToAI: true)
    
    var victoryIconID: UInt8 {
        kind.victoryIconID
    }
    
    enum Kind: Hashable {
        /// You must find a specific artifact. Win by placing the artifact in one of your heroes’ backpacks.
        case acquireSpecificArtifact(Artifact.ID)
        
        /// Your kingdom must acquire X number of a specific type of creature.
        case accumulateCreatures(kind: Creature.ID, amount: Int)
        
        ///  Your kingdom must acquire X amount of a specific resource.
        case accumulateResources(kind: Resource.Kind, quantity: Resource.Quantity)
        
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
    enum Stripped: UInt8, Equatable, CustomStringConvertible {
        
        /// You must find a specific artifact. Win by placing the artifact in one of your heroes’ backpacks.
        case acquireSpecificArtifact
        
        /// Your kingdom must acquire X number of a specific type of creature.
        case accumulateCreatures
        
        ///  Your kingdom must acquire X amount of a specific resource.
        case accumulateResources
        
        /// The hall and castle of a given town must be upgraded to a specified level.
        case upgradeSpecificTown
        
        /// Find the Grail and build a grail building in one of your towns.
        case buildGrailBuilding
        
        /// Defeat a specified hero.
        case defeatSpecificHero
        
        /// Occupy a specified town.
        case captureSpecificTown
        
        /// Defeat a specified wandering monster.
        case defeatSpecificCreature
        
        /// You must control all the creature dwellings/generators on the map.
        case flagAllCreatureDwellings
        
        ///  Control all the mines on the map.
        case flagAllMines
        
        /// Acquire a specific artifact and transport it to a specified town.
        case transportSpecificArtifact
        
        /// Conquer all enemy towns and defeat all enemy heroes.
        ///
        /// Standard win condition.
        case defeatAllEnemies = 255
    }
}


public extension Map.VictoryCondition.Kind.Stripped {
    static let standard: Self = .defeatAllEnemies
    
    var description: String {
        switch self {
        case .acquireSpecificArtifact: return "acquireSpecificArtifact"
        case .defeatAllEnemies: return "defeatAllEnemies"
        case .accumulateCreatures: return "accumulateCreatures"
        case .accumulateResources: return "accumulateResources"
        case .captureSpecificTown: return "captureSpecificTown"
        case .flagAllCreatureDwellings: return "flagAllCreatureDwellings"
        case .flagAllMines: return "flagAllMines"
        case .upgradeSpecificTown: return "upgradeSpecificTown"
        case .buildGrailBuilding: return "buildGrailBuilding"
        case .defeatSpecificHero: return "defeatSpecificHero"
        case .defeatSpecificCreature: return "defeatSpecificCreature"
        case .transportSpecificArtifact: return "transportSpecificArtifact"
        }
    }
}

public extension Map.VictoryCondition.Kind {
    var position: Position? {
        switch self {
        case .buildGrailBuilding(let townPosition): return townPosition
        case .captureSpecificTown(let townPosition): return townPosition
        case .defeatSpecificCreature(let creaturePosition): return creaturePosition
        case .defeatSpecificHero(let heroPosition): return heroPosition
        case .transportSpecificArtifact(_, let townPosition): return townPosition
        case .upgradeSpecificTown(let townPosition, _,  _): return townPosition
        case .accumulateCreatures, .accumulateResources, .acquireSpecificArtifact, .defeatAllEnemies, .flagAllCreatureDwellings, .flagAllMines: return nil
        }
    }
}

public extension Map.VictoryCondition {
    var position: Position? { kind.position }
}

