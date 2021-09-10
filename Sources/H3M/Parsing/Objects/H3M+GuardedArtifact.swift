//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension Map.Loader.Parser.H3M {
    func parseGuardedArtifact(format: Map.Format, objectID: Map.Object.ID) throws -> Map.GuardedArtifact {
        let (message, guardians) = try parseMessageAndGuardians(format: format)
        let artifact: Artifact
        if case let .spellScroll(expectedSpellScrollID) = objectID {
            let spellIDParsed = try Spell.ID(integer: reader.readUInt32())
            assert(spellIDParsed == expectedSpellScrollID)
            artifact = .scroll(spell: spellIDParsed)
        } else if case let .artifact(specificArtifactID) = objectID {
            artifact =  .specific(id: specificArtifactID) //.init(id: expectedArtifactID)
        } else if case .randomMajorArtifact = objectID {
            artifact = .random(class: .major) //.init(id: .random(class: .major, in: format))
        } else if case .randomMinorArtifact = objectID {
            artifact = .random(class: .minor) //.init(id: .random(class: .minor, in: format))
        } else if case .randomRelic = objectID {
            artifact = .random(class: .relic) //.init(id: .random(class: .relic, in: format))
        } else if case .randomTreasureArtifact = objectID {
            artifact = .random(class: .treasure) //.init(id: .random(class: .treasure, in: format))
        } else if case .randomArtifact = objectID {
            artifact = .random(class: .any) //.init(id: .random(class: .any, in: format))
        } else { fatalError("incorrect implementation, unhandled object ID: \(objectID)") }

        return  .init(artifact, message: message, guardians: guardians)
      
      
    }
}
