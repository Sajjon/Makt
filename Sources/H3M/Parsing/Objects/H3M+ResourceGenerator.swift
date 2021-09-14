//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm
import Util

extension H3M {
    
    func parseResourceGenerator(
        kind placeholder: Map.ResourceGenerator.Kind.Placeholder
    ) throws -> Map.ResourceGenerator {
        let kind: Map.ResourceGenerator.Kind
        switch placeholder {
        case .abandonedMine: incorrectImplementation(reason: "Should not parse abandoned mine as a regular mine.")
        case .alchemistsLab: kind = .alchemistsLab
        case .crystalCavern: kind = .crystalCavern
        case .gemPond: kind = .gemPond
        case .goldMine: kind = .goldMine
        case .sawmill: kind = .sawmill
        case .orePit: kind = .orePit
        case .sulfurDune: kind = .sulfurDune
        }
        let mine = try Map.ResourceGenerator(kind: kind, owner: .init(rawValue: reader.readUInt8()))
        try reader.skip(byteCount: 3)
        return mine
    }

}
