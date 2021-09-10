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

    // WARNING untested method
    func parsePlaceholderHero() throws -> Hero.Placeholder {
        guard let owner = try parseOwner() else { incorrectImplementation(reason: "A placeholder hero should always have an owner, right?") }
        let identityRaw = try reader.readUInt8()
        let identity: Hero.Placeholder.Identity = try identityRaw == 0xff ? .anyHero(powerRating: .init(integer: reader.readUInt8())) : .specificHero(.init(integer: identityRaw))
        
        return .init(owner: owner, identity: identity)
    }
    
}
