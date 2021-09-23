//
//  File.swift
//  File
//
//  Created by Alexander Cyon on 2021-09-10.
//

import Foundation
import Malm

extension H3M {
    
    func parseSign() throws -> Map.Sign {
        // Yes aparantly signs can be without message, seen in bundled map `Realm of Chaos`, position (x: 20, y: 47).
        let message: String? = try reader.readLengthOfStringAndString(assertingMaxLength: 1000) // arbitrarily chosen
        try reader.skip(byteCount: 4)
        return .init(message: message)
    }
    
    
}
